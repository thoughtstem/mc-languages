#lang racket

(provide languages-pages)

(require website/bootstrap
         website-scribble
         ts-kata-util/katas/main
         (only-in ts-adventure/katas adventure-katas)
         (only-in ts-survival/katas survival-katas)
         "./rendering.rkt")

;Move to site?

(define (languages-head-content)
 (list 
  (scribble-includes)
  (include-css "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/themes/prism.css")
  (include-js "https://cdn.jsdelivr.net/npm/prismjs@1.17.1/prism.min.js")
  (include-js "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/plugins/autoloader/prism-autoloader.min.js")))


(require (prefix-in adventure: (lib "adventure/scribblings/manual.scrbl")))

(define (lang-page name katas docs-location #:wrap-content (wrap content))

 (define doc (dynamic-require docs-location 'doc))

 (page (list (~a name ".html"))
  (wrap #:head (languages-head-content)
    (container 
     (h2 "#lang " name)
     (tabify 
      (active-tab-nav-link 
       href: "#translations" 
       "Translations")
      (tab-nav-link 
       href: "#documentation"
       "Documentation")
      (active-tab-pane 
       id: "translations" class: "p-3"
       (map kata->html (kata-collection-katas katas)))
      (tab-pane 
       id: "documentation" class: "p-3"
       (scribble->html doc (~a name "-doc"))))))))

(define (languages-index-page #:wrap-content (wrap content))
 (page index.html
  (wrap #:head (languages-head-content)
   (container 
    (h1 "Languages")
    (card-deck
     ;TODO: Extract this lang card functionality.
     (card 
      (card-header
       (button-link
        (link-to "adventure.html" "#lang adventure")))
      ;Put badges? Put some kind of unique graphic, so the languages don't all look the same and boring...
      (card-body
       (card-text "For creating adventure games.")))
     (card 
      (card-header
       (button-link
        (link-to "survival.html" "#lang survival")))
      ;Put badges?
      (card-body
       (card-text "For creating survival games.")))
     (card 
      (card-header
       (button-link
        (link-to "website.html" "website")))
      ;Put badges?
      (card-body
       (card-text "For creating websites")))
       )))))

(define (languages-pages #:wrap-content (wrap content))
  (list
    (scribble-files)
    (languages-index-page #:wrap-content wrap) 
    (lang-page "adventure" adventure-katas '(lib "adventure/scribblings/manual.scrbl") #:wrap-content wrap)
    (lang-page "survival"  survival-katas  '(lib "survival/scribblings/manual.scrbl")  #:wrap-content wrap)
    (lang-page "website"   (kata-collection '()) '(lib "website/scribblings/website.scrbl")  #:wrap-content wrap)
    ))

(module+ main
   (render (list 
            (bootstrap-files)
            (languages-pages))
           #:to "out"))

