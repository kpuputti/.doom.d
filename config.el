;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Kimmo Puputti"
      user-mail-address "emacs@kimmo.kpuputti.fi")
(setq doom-theme 'doom-vibrant)
(setq org-directory "~/org/")
(setq display-line-numbers-type t)

(defconst is-mac (eq system-type 'darwin))

(when is-mac
  (setq mac-option-modifier nil
        mac-command-modifier 'meta))

(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol)

      ;; http://emacsredux.com/blog/2013/04/07/display-visited-files-path-in-the-frame-title/
      frame-title-format '((:eval (if (buffer-file-name)
                                      (abbreviate-file-name (buffer-file-name))
                                    "%b")))

                                        ; https://github.com/hlissner/doom-emacs/issues/4158
      +format-with-lsp nil)

(after! undo-tree (setq undo-tree-enable-undo-in-region t))

(after! whitespace
  (setq whitespace-style '(face tabs tab-mark trailing empty))
  (global-whitespace-mode +1))

(after! magit
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1
        magit-bury-buffer-function  #'magit-restore-window-configuration))

(after! anzu (global-anzu-mode +1))

(map! "C-a" #'beginning-of-line
      "M-o" #'ace-window
      "M-/" #'hippie-expand
      "C-c b" #'+default/new-buffer)

(add-to-list 'auto-mode-alist '("\\.sqlx\\'" . sql-mode))

(use-package! graphql-mode
  :defer t)

(after! polymode
  (require 'graphql-mode)

  (define-hostmode typescript-hostmode
    :mode 'typescript-mode)

  (define-innermode graphql-innermode
    :mode 'graphql-mode
    :head-matcher "gql`"
    :tail-matcher "`"
    :head-mode 'host
    :tail-mode 'host)

  (define-polymode poly-typescript-mode
    :hostmode 'typescript-hostmode
    :innermodes '(graphql-innermode))

  (add-to-list 'auto-mode-alist
               '("\\.ts\\'" . poly-typescript-mode)))

(defun my/copy-file-name ()
  "Copy the base name (no path) of the current buffer's file to the clipboard.
If the buffer is not visiting a file, display a message."
  (interactive)
  (let ((full-path (buffer-file-name)))
    (if full-path
        (let ((basename (file-name-nondirectory full-path)))
          (kill-new basename)
          (message "Copied file basename: %s" basename))
      (message "Buffer is not visiting a file."))))

(use-package! gptel
  :config
  (setq
   gptel-api-key (lambda () (getenv "GEMINI_API_KEY"))
   gptel-model 'gemini-2.5-pro
   gptel-backend (gptel-make-gemini "Gemini"
                   :key (lambda () (getenv "GEMINI_API_KEY"))
                   :stream t)))
