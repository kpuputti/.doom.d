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

(use-package typescript-ts-mode
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :config
  (add-hook! '(typescript-ts-mode-hook tsx-ts-mode-hook) #'lsp!))

(after! lsp-mode
  (dolist (dir '("[/\\\\]pgdata\\'"
                 "[/\\\\]db/pgdata\\'"
                 "[/\\\\]dist\\'"
                 "[/\\\\]\\.next\\'"
                 "[/\\\\]\\.cache\\'"))
    (push dir lsp-file-watch-ignored-directories))
  (setq lsp-file-watch-threshold 50000))

(add-to-list 'auto-mode-alist '("\\.sqlx\\'" . sql-mode))

(after! markdown-mode
  (setq markdown-command "pandoc -f gfm -t html")
  (defun my/markdown-preview-css ()
    (let ((f (expand-file-name "markdown-preview.css" doom-user-dir)))
      (if (file-readable-p f)
          (format "<style>\n%s\n</style>"
                  (with-temp-buffer (insert-file-contents f) (buffer-string)))
        "")))
  (defun my/markdown-refresh-header-content (&rest _)
    (setq markdown-xhtml-header-content (my/markdown-preview-css)))
  (advice-add 'markdown-preview :before #'my/markdown-refresh-header-content)
  (my/markdown-refresh-header-content))

(use-package! graphql-mode
  :defer t)

(use-package! gptel
  :config
  (setq
   gptel-api-key (lambda () (getenv "GEMINI_API_KEY"))
   gptel-model 'gemini-3-pro-preview
   gptel-backend (gptel-make-gemini "Gemini"
                   :key (lambda () (getenv "GEMINI_API_KEY"))
                   :stream t)
   gptel-include-reasoning nil))

(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))
