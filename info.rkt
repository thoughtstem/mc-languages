#lang info
(define collection "mc-languages")
(define deps '("base"
               "https://github.com/thoughtstem/website.git"
               "https://github.com/thoughtstem/website-js.git"
               "https://github.com/thoughtstem/website-scribble.git"
               "https://github.com/thoughtstem/TS-VR-Languages.git?path=3d-exploration"
               "https://github.com/thoughtstem/TS-VR-Katas.git?path=ts-3d-exploration"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/mc-languages.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(thoughtstem))
