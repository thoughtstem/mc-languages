#lang at-exp racket

(provide kata->html)

(require ts-kata-util
         ts-kata-util/katas/main
         (only-in scribble/manual racketblock)
         syntax/stx syntax/to-string
         website-js)
         

(define (cardify #:header (header "") . xs)
   (card class: "mb-1"
     (card-header class: "bg-info text-white" (b header))
     (card-body (card-text xs))))

(define (wrap-parens s)
  (string-append "(" s ")"))

(define (symbol->title s)
  (string-titlecase (string-replace (~a s) "-" " ")))

(define (specification-toggle-card k)
  (define stimulus
    (stimulus-data (kata-stimulus k)))
  
 (card
  (card-header 
   (button-link 
     on-click: (call 'toggledSpecification) 
     'data-toggle: "collapse" 
     'data-target: (ns# "specification") 
     (i id: (ns "specification-next-state") 
        class: "fa fa-eye") 
        " Specification"))

  (div id: (ns "specification") 
       class: "collapse show" 
       'data-parent: (ns# "accordion")
   (card-body 
    (card-text
     (~a (expression-data stimulus))

     )))))

(define (implementation-toggle-card k)
  (define res
    (response-data (kata-response k)))

  
  (define code-s
    (if (kata->syntax k)
        (string-join 
         (map (compose wrap-parens syntax->string)
              ;Drop 3 to get rid of (module name lang ...)
              (drop (stx->list (kata->syntax k)) 3))
         "\n\n")
        ;Have to handle the ratchet katas differently, and it's a bit of a mess.
        ;TODO: One day, simplify the kata data structure
        (let ([ed (expression-data res)])
          (when (not (string? (first ed)))
            (expression-data (first ed)))
          )))

  (define maybe-ratchet-img
    (if (kata->syntax k)
        #f
        (let ([ed (expression-data res)])
          (list
           (h5 "In Ratchet:")
           (write-img (last ed))))))

  (card
   (card-header
    (button-link 
     on-click: (call 'toggledImplementation) ;set state...
     'data-toggle: "collapse" 
     'data-target: (ns# "implementation") 
     (i id: (ns "implementation-next-state") 
        class: "fa fa-eye")  ;sync state...
     " Implementation"))

   (div id: (ns "implementation") class: "collapse show"
        (card-body 
         (div class: "button-group"
              (button-danger 
               on-click: (call 'disintegrate) 
               'data-toggle: "tooltip" 'data-placement: "top" 
               'title: "Remove random word" 
               (i class: "fas fa-crosshairs")))
         (card-text 
          (pre 
           (code class: "lang-scheme" code-s))
          maybe-ratchet-img
          )))))

(define (kata->html k)
  (define res
    (response-data (kata-response k)))

  (define stim
    (stimulus-data (kata-stimulus k)))


  ;Filters out katas like the Code of Awesomeness katas, which are not coding katas
  ;TODO: Don't use katas for things that aren't coding exercises (that would be a game or a story now)
  (when (and (not (string? res))
             (not (string? stim))) 
   (enclose
       (cardify #:header (symbol->title (kata-id k))
        (responsive-row #:columns 2
          (specification-toggle-card k)
          (implementation-toggle-card k)
         ))
        (script ([specificationShown 'true]
                 [implementationShown 'true]
                 [specificationIconId (ns "specification-next-state")]
                 [implementationIconId (ns "implementation-next-state")]
                 [prismHacked 'false])

          (function (hackPrism)
            @js{
              if(@prismHacked) return;
              @prismHacked = true;

              var ns = Array.from(document.querySelector("@(id# "implementation") pre code").childNodes).filter((x)=>{return x.nodeType == 3})

              ns.map((n)=>{
                var s = n.wholeText
                //Probably buggy...
                var ss = s.split(" ").map((s)=>"<span class='token'>" + s + "</span>")
                $(n).replaceWith(ss.join(" "))
              })
            })

          (function (toggledSpecification)
            @js{@specificationShown = !@specificationShown}
            (call 'render)) 

          (function (toggledImplementation)
            @js{@implementationShown = !@implementationShown}
            (call 'render))

          (function (implementationNextState)
            @js{return @implementationShown ? "fa fa-eye-slash" : "fa fa-eye"})

          (function (specificationNextState)
            @js{return @specificationShown ? "fa fa-eye-slash" : "fa fa-eye"})

          (function (disintegrate)
            @js{
              @hackPrism();
              var ns = document.querySelector("@(id# "implementation") pre code").childNodes;
              var maybeHide = Array.from(ns).filter(
                 (x) => 
                   (!x.className
                    || 
                    x.className && !x.className.match(/punctuation/))
                   &&
                   (!x.style || 
                    (x.style && x.style.opacity != "0"))
                   &&
                   x.innerHTML
                   &&
                   !x.innerHTML.match(/^\s+$/)
              );

              var toHide = maybeHide[Math.floor(Math.random() * maybeHide.length)]
              if(toHide)
                $(toHide).animate({opacity: 0})
            })

          (function (render)
            @js{@getEl{@specificationIconId}.className  = @specificationNextState()}
            @js{@getEl{@implementationIconId}.className = @implementationNextState()}) ))

  ))

