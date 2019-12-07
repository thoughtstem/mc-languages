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
            
            (map kata->html (kata-collection-katas katas))))))

(module+ main
   (render (list 
            (bootstrap-files)
            (index))
           #:to "out"))

