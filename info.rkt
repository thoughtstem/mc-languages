#lang info
(define collection "mc-languages")
(define deps '("base"
               "https://github.com/thoughtstem/website.git"
               "https://github.com/thoughtstem/website-js.git"
               "https://github.com/thoughtstem/website-scribble.git"
               "https://github.com/thoughtstem/TS-GE-Languages.git?path=adventure"
               "https://github.com/thoughtstem/TS-GE-Katas.git?path=ts-adventure"
               "https://github.com/thoughtstem/TS-GE-Languages.git?path=survival"
               "https://github.com/thoughtstem/TS-GE-Katas.git?path=ts-survival"
               "https://github.com/thoughtstem/TS-GE-Languages.git?path=battlearena"
               "https://github.com/thoughtstem/TS-GE-Katas.git?path=ts-battle-arena"
               "https://github.com/thoughtstem/TS-VR-Languages.git?path=3d-exploration"
               "https://github.com/thoughtstem/TS-VR-Katas.git?path=ts-3d-exploration"
               "https://github.com/thoughtstem/TS-K2-Languages.git?path=healer-animal-lib"
               "https://github.com/thoughtstem/TS-K2-Katas.git?path=ts-k2-healer"
                ))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/mc-languages.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(thoughtstem))
