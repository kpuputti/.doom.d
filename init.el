;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

(doom! :app

       :checkers
       (syntax +childframe)
       spell

       :completion
       (company +childframe)
       (vertico +icons)

       :config
       (default +bindings +smartparens)

       :editor
       (format +onsave)

       :emacs
       (dired +dirvish +icons)
       electric
       (undo +tree)
       vc

       :email

       :input

       :lang
       emacs-lisp
       javascript
       json
       lua
       (markdown +grip)
       org
       sh
       web
       yaml

       :os
       (:if IS-MAC macos)

       :term
       eshell

       :tools
       editorconfig
       (eval +overlay)
       lookup
       magit
       terraform

       :ui
       doom
       doom-dashboard
       doom-quit
       hl-todo
       indent-guides
       modeline
       nav-flash
       ophints
       (popup +defaults)
       vc-gutter
       vi-tilde-fringe
       window-select
       workspaces)
