#lang info
(define collection "mc-languages")
(define deps '("base"
               "https://github.com/thoughtstem/website.git"
               "https://github.com/thoughtstem/website-js.git"
               "https://github.com/thoughtstem/website-scribble.git"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/mc-languages.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(thoughtstem))
