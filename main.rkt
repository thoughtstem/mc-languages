#lang racket

(provide languages-pages)

(require website/bootstrap
         website-scribble
         ts-kata-util/katas/main
         (only-in ts-adventure/katas adventure-katas)
         (only-in ts-survival/katas survival-katas)
         (only-in ts-3d-exploration/katas exploration-katas)
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
     (lang-card "adventure" "For creating adventure games")
     (lang-card "survival" "For creating survival games")
     (lang-card "website" "For making websites")
     (lang-card "3d-exploration" "For making 3d scenes"))))))

(define (lang-card name desc)
 (card 
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
    (lang-page "website"   (kata-collection '()) '(lib "website/scribblings/website.scrbl")  #:wrap-content wrap)
    (lang-page "3d-exploration" exploration-katas '(lib "3d-exploration/scribblings/manual.scrbl")  #:wrap-content wrap)))

(module+ main
   (render (list 
            (bootstrap-files)
            (languages-pages))
           #:to "out"))

