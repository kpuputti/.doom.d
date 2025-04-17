;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! anzu)
(package! restclient)
(package! graphql-mode)
(package! ag)

(package! jsonrpc)
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

(package! polymode)
