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
         (only-in ts-3d-orbit/katas orbit-lang-katas)
         (only-in ts-k2-clicker/katas/pokemon pokemon)
         (only-in ts-k2-clicker/katas/cartoon cartoon)
         "./rendering.rkt")

;Move to site?

(define (languages-head-content)
 (list 
  (scribble-includes)
  (include-css "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/themes/prism.css")
  (include-js "https://cdn.jsdelivr.net/npm/prismjs@1.17.1/prism.min.js")
  (include-js "https://cdn.jsdelivr.net/gh/PrismJS/prism@1.17.1/plugins/autoloader/prism-autoloader.min.js")))


(require (prefix-in adventure: (lib "adventure/scribblings/manual.scrbl")))

(define (lang-page name katas docs-location #:wrap-content [wrap content] #:install-name [install-name #f]#:lang-desc [lang-desc #f])

  (define desc
    (if lang-desc
        (card (card-header "About this Language")
              (card-body lang-desc))
        #f))

  (define install-info
    (if install-name
        (card (card-header "To Install")
              (card-body
               (p "Package Source: " (b install-name) )
               ;TODO move video to youtube asap
               (p "Need a reminder how to install a package? Check out " (a href: "https://drive.google.com/file/d/1WAz_JyzR3V2fKXW7TxbCPaJob76zlJAv/view?usp=sharing" "this video!"))
               ))
        #f))
  
  (define info-section
    (if (and desc install-info)
        (responsive-row #:columns 2 desc install-info)
        (or desc install-info)))

 (define doc (dynamic-require docs-location 'doc))

 (page (list (~a name ".html"))
  (wrap #:head (languages-head-content)
    (container 
     (h2 "#lang " name)
     info-section
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
       (map kata->html
            (bring-hello-world-kata-top (kata-collection-katas katas))))
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
      (lang-card "3d-orbit" "For making 3D space scenes.")
      (lang-card "healer-animal" "A ratchet lang for making healer games.")
      (lang-card "clicker-cartoon" "A ratchet lang for making clicker games with cartoon sprites.")
      (lang-card "clicker-pokemon" "A ratchet lang for making clicker games with pokemon sprites.")
      )))))

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
    (lang-page "adventure" adventure-katas '(lib "adventure/scribblings/manual.scrbl") #:wrap-content wrap
               #:install-name "adventure"
               #:lang-desc (list (p "Use this language to create your own adventure-style game!")
                                 (ul (li "Customize your avatar!")
                                     (li "Add enemies and NPCs -- Non-Player Characters!")
                                     (li "Customize QUESTS for your avatar to complete!")
                                     (li "Use cutscenes to add story to your game!"))))
    (lang-page "survival"  survival-katas  '(lib "survival/scribblings/manual.scrbl")  #:wrap-content wrap
               #:install-name "survival"
               #:lang-desc (list (p "Use this language to create your own survival-style game!")
                                 (ul (li "Customize your avatar!")
                                     (li "Add food to help your avatar battle hunger!")
                                     (li "Add enemies for extra challenges!")
                                     (li "Customize recipies and craft new foods and weapons in game!")
                                     (li "Dabble in level design!"))))
    (lang-page "battlearena" battle-arena-katas '(lib "battlearena/scribblings/manual.scrbl") #:wrap-content wrap
               #:install-name "battlearena")
    (lang-page "website"   (kata-collection '()) '(lib "website/scribblings/website.scrbl")  #:wrap-content wrap)
    (lang-page "3d-exploration" exploration-katas '(lib "3d-exploration/scribblings/manual.scrbl")  #:wrap-content wrap
               #:install-name "https://github.com/thoughtstem/TS-VR-Languages.git?path=3d-exploration"
               #:lang-desc (list (p "Use this language to create your own 3D worlds to explore!")
                                 (ul (li "Customize environments with presets, dressing, colors and more!")
                                     (li "Add completely customizable 3D objects!")
                                     (li "Add particle generators; like dust, rain or flying dragons!")
                                     (li "Animate shapes and 3D models in your world!"))))
    (lang-page "3d-orbit" orbit-lang-katas '(lib "3d-orbit/scribblings/manual.scrbl")  #:wrap-content wrap
               #:install-name "https://github.com/thoughtstem/TS-VR-Languages.git?path=3d-orbit"
               #:lang-desc (list (p "Use this language to create 3D space scenes to explore!")
                                 (ul (li "Customize stars and planets with textures, rings, and more.")
                                     (li "Create soloar systems with orbiting planets, moons and asteroids!")
                                     (li "Add 3D models into your space scene!")
                                     (li "Let your imagination run wild!"))))
    (lang-page "healer-animal" animal '(lib "healer-animal-lib/scribblings/healer-animal-lib.scrbl") #:wrap-content wrap
               #:install-name "https://github.com/thoughtstem/TS-K2-Languages.git?path=healer-animal"
               #:lang-desc (list
                            (p "Use this " (b "Ratchet-enabled") " language to create your own healer game!")
                            (ul (li "Customize your avatar!")
                                (li "Add yummy food to eat!")
                                (li "Add friend and heal them for points!")
                                (li "Add enimies for an extra challenge!"))
                            (p (b "TIP:") " This is a language collection that actually includes 3 language levels -- be sure to check the lang line for a given section before attempting to write the code in Ratchet.")))
    (lang-page "clicker-cartoon" cartoon '(lib "clicker-cartoon-lib/scribblings/clicker-cartoon-lib.scrbl") #:wrap-content wrap
               #:install-name "https://github.com/thoughtstem/TS-K2-Languages.git?path=clicker-cartoon"
               #:lang-desc (list
                            (p "Use this " (b "Ratchet-enabled") " language to create your own clicker game!")
                            (ul (li "Customize your avatar!")
                                (li "Add collectables to click for points!")
                                (li "Add avoidables that will chase you!")
                                (li "Add special items for extra fun!"))
                            (p (b "TIP:") " This is a language collection that actually includes 3 language levels -- be sure to check the lang line for a given section before attempting to write the code in Ratchet.")))
    (lang-page "clicker-pokemon" pokemon '(lib "clicker-pokemon-lib/scribblings/clicker-pokemon-lib.scrbl") #:wrap-content wrap
               #:install-name "https://github.com/thoughtstem/TS-K2-Languages.git?path=clicker-cartoon"
               #:lang-desc (list
                            (p "Use this " (b "Ratchet-enabled") " language to create your own pokemon-themed clicker game!")
                            (ul (li "Customize your avatar to your favorite pokemon!")
                                (li "Add stones to collect for points!")
                                (li "Add trainers that will chase you!")
                                (li "Add special items for extra fun!"))
                            (p (b "TIP:") " This is a language collection that actually includes 3 language levels -- be sure to check the lang line for a given section before attempting to write the code in Ratchet.")))
    )
  )

(module+ main
  (with-prefix "mc-languages" ;Remove this when we host it at languages.metacoders.org
    (render (list 
              (bootstrap-files)
              (languages-pages))
            #:to "out")))

