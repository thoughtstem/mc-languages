#lang racket

(provide kata->html)

(require ts-kata-util
         ts-kata-util/katas/main
         website/bootstrap
         (only-in scribble/manual racketblock)
         syntax/stx syntax/to-string)
         

(define (cardify . xs)
   (card (card-body (card-text xs))))

(define (wrap-parens s)
  (string-append "(" s ")"))

(define (kata->html k)
   (define s (kata->syntax k))

   (when s
      (define code-s
         (string-join 
            (map (compose wrap-parens syntax->string)
                ;Drop 3 to get rid of (module name lang ...)
                (drop (stx->list s) 3))
            "\n\n"))

      (cardify 
        (div
          (~a (expression-data (stimulus-data (kata-stimulus k)))))
        (div
          (pre
            (code class: "lang-scheme" code-s))))))

(module+ test)
