#lang racket

(provide languages-pages)

(require website/bootstrap
         ts-kata-util/katas/main
         (only-in ts-adventure/katas adventure-katas)
         (only-in ts-survival/katas survival-katas)
         "./rendering.rkt")

;Move to site?

(define (languages-head-content)
 (list 
  (include-css "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/themes/prism.css")
  (include-js "https://cdn.jsdelivr.net/npm/prismjs@1.17.1/prism.min.js")
  (include-js "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/plugins/autoloader/prism-autoloader.min.js")))

(define (lang-page name katas #:wrap-content (wrap content))
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
       (h3 "Documentation")))))))

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
       (card-text "For creating survival games."))))))))

(define (languages-pages #:wrap-content (wrap content))
  (list
    (languages-index-page #:wrap-content wrap) 
    (lang-page "adventure" adventure-katas #:wrap-content wrap)
    (lang-page "survival"  survival-katas #:wrap-content wrap)))

(module+ main
   (render (list 
            (bootstrap-files)
            (languages-pages))
           #:to "out"))

