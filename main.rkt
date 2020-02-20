#lang racket

(provide languages-pages)

(require website/bootstrap
         website-scribble
         ts-kata-util/katas/main
         (only-in ts-adventure/katas adventure-katas)
         (only-in ts-survival/katas survival-katas)
         (only-in ts-battle-arena/katas battle-arena-katas)
         (only-in ts-3d-exploration/katas exploration-katas)
         (only-in ts-k2-healer/katas/animal animal)
         "./rendering.rkt")

;Move to site?

(define (languages-head-content)
 (list 
  (scribble-includes)
  (include-css "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/themes/prism.css")
  (include-js "https://cdn.jsdelivr.net/npm/prismjs@1.17.1/prism.min.js")
  (include-js "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/plugins/autoloader/prism-autoloader.min.js")))


(require (prefix-in adventure: (lib "adventure/scribblings/manual.scrbl")))

(define (lang-page name katas docs-location #:wrap-content [wrap content] #:lang-desc [lang-desc #f])

  (define desc
    (if lang-desc
        (card (card-header "About this Language")
              (card-body lang-desc))
        #f))

 (define doc (dynamic-require docs-location 'doc))

 (page (list (~a name ".html"))
  (wrap #:head (languages-head-content)
    (container 
     (h2 "#lang " name)
     desc
     (if lang-desc (br) #f)
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
    (responsive-row #:columns 4 #:padding 2
      (lang-card "adventure" "For creating adventure games.")
      (lang-card "survival" "For creating survival games.")
      (lang-card "battlearena" "For creating battle arena games.")
      (lang-card "website" "For making websites.")
      (lang-card "3d-exploration" "For making 3D scenes.")
      (lang-card "healer-animal" "A ratchet lang for making healer games."))))))

(define (lang-card name desc)
 (card class: "h-100"
  (card-header
   (button-link
    (link-to (~a name ".html") name)))
  ;Put badges?
  (card-body
   (card-text desc))))

(define (languages-pages #:wrap-content (wrap content))
  (list
    (scribble-files)
    (languages-index-page #:wrap-content wrap) 
    (lang-page "adventure" adventure-katas '(lib "adventure/scribblings/manual.scrbl") #:wrap-content wrap)
    (lang-page "survival"  survival-katas  '(lib "survival/scribblings/manual.scrbl")  #:wrap-content wrap)
    (lang-page "battlearena" battle-arena-katas '(lib "battlearena/scribblings/manual.scrbl") #:wrap-content wrap)
    (lang-page "website"   (kata-collection '()) '(lib "website/scribblings/website.scrbl")  #:wrap-content wrap)
    (lang-page "3d-exploration" exploration-katas '(lib "3d-exploration/scribblings/manual.scrbl")  #:wrap-content wrap)
    (lang-page "healer-animal" animal '(lib "healer-animal-lib/scribblings/healer-animal-lib.scrbl") #:wrap-content wrap
               #:lang-desc (list
                            (p "This is a ratchet language best for young elementary coders. Customize your avatar, add food to eat, friends to heal, and enemies to avoid!")
                            (p (b "TIP:") " This is a language collection that actually includes 3 language levels -- be sure to check the lang line for a given section before attempting to write the code in Ratchet.")))
    ))

(module+ main
  (with-prefix "mc-languages" ;Remove this when we host it at languages.metacoders.org
    (render (list 
              (bootstrap-files)
              (languages-pages))
            #:to "out")))

