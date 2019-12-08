#lang racket

(require website/bootstrap
         ts-kata-util/katas/main
         (rename-in ts-adventure/katas 
                    [adventure-katas katas])
         "./rendering.rkt")

(define (index)
  (page index.html
        (content
          #:head (list 
                    (include-css "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/themes/prism.css")
                    (include-js "https://cdn.jsdelivr.net/npm/prismjs@1.17.1/prism.min.js")
                    (include-js "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/plugins/autoloader/prism-autoloader.min.js"))
          (container 
            (h2 "#lang adventure")
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
                  (h3 "Documentation")
                  ))))))

(module+ main
   (render (list 
            (bootstrap-files)
            (index))
           #:to "out"))

