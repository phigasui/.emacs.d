
;;; Code:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(jest highlight-indent-guides forge ddskk package-utils rspec-mode adoc-mode csv-mode sqlformat julia-repl julia-mode json-mode multiple-cursors string-inflection markdown-mode open-junk-file tide git-gutter-fringe rubocop eglot find-file-in-project flycheck counsel yaml-mode magit web-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package
 '(prisma-mode :type git :host github :repo "pimeys/emacs-prisma-mode"))

(straight-use-package
 '(copilot :type git :host github :repo "zerolfx/copilot.el" :files ("dist" "*.el")))

;; Package Managements
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(package-refresh-contents)

(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))

;; Functions
(defun copy2clipboard ()
  "Copy to clipboard."
  (interactive)
  (when (region-active-p)
    (shell-command-on-region (region-beginning) (region-end) "pbcopy" nil nil)))

(defun sort-js-import-lines (beg end)
  "Sort import lines from BEG to END."
  (interactive (list (region-beginning) (region-end)))
  (sort-regexp-fields nil "^import.+$" "from.+" beg end))

(defun counter-other-window ()
  "Focus other window conterly."
  (interactive)
  (other-window -1))

;; Theme
(load-theme 'whiteboard t)

;; Global Settings
(require 'dired)
(electric-pair-mode t)
(global-display-line-numbers-mode)
(setq-default indent-tabs-mode nil)
(set-language-environment "UTF-8")
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq dired-dwim-target t)

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(add-hook 'prog-mode-hook 'global-whitespace-mode)
(add-hook 'find-file-hook (lambda () (skk-latin-mode 1)))

;; Global Key Binds
(define-key global-map (kbd "C-h" ) 'delete-backward-char)
(define-key global-map (kbd "M-x") 'counsel-M-x)
(define-key global-map (kbd "C-s") 'swiper-isearch)
(define-key global-map (kbd "C-r") 'swiper-isearch-backward)
(define-key global-map (kbd "C-c g") 'counsel-git-grep)
(define-key global-map (kbd "C-c f") 'counsel-git)
(define-key global-map (kbd "C-c c") 'copy2clipboard)
(define-key global-map (kbd "C-x O") 'counter-other-window)
(define-key global-map (kbd "C-c RET") 'find-file-at-point)

;; skk Settings
(require 'skk)
(setq default-input-method "japanese-skk")
(setq skk-server-host "localhost")
(setq skk-server-portnum 1178)
(setq skk-jisyo-code 'utf-8)
(setq skk-egg-like-newline t)
(setq skk-show-annotation t)
(setq skk-delete-implies-kakutei nil)
(setq skk-annotation-delay 0)
(setq skk-show-tooltip t)

(setq skk-rom-kana-rule-list
      (append '(("c" nil skk-abbrev-mode)
                )
              skk-rom-kana-rule-list))
(defconst overriding-skk-rom-kana-base-rule-list
  (seq-filter (lambda (x) (cond ((stringp (car x)) (not (string= (substring (car x) 0 1) "c"))))) skk-rom-kana-base-rule-list)
              )

(setq skk-rule-tree
      (skk-compile-rule-list
       overriding-skk-rom-kana-base-rule-list skk-rom-kana-rule-list))

;; Git Settings
(require 'magit-mode)
(with-eval-after-load 'magit
  (require 'forge))
(define-key magit-mode-map (kbd "C-c C-w") 'forge-browse-dwim)
(require 'magit-diff)
(setq magit-diff-refine-hunk t)

(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer buffer '(display-buffer-same-window))))


;; GitHub Copilot Settings
(require 'copilot)
(add-hook 'prog-mode-hook 'copilot-mode)

(with-eval-after-load 'company
  ;; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends))

(define-key copilot-completion-map (kbd "C-p") 'copilot-previous-completion)
(define-key copilot-completion-map (kbd "C-n") 'copilot-next-completion)
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;; whitespace Settings
(require 'whitespace)
(setq whitespace-style '(face
                         tabs
                         ;;spaces
                         trailing
                         ;;lines
                         space-before-tab
                         ;;newline
                         indentation
                         empty
                         space-after-tab
                         ;;space-mark
                         tab-mark
                         ;;newline-mark
                         ))


;; ivy Settings
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")


;; company Settings
(require 'company)
(global-company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)


;; eglot Settings
(require 'eglot)
(add-hook 'ruby-mode-hook 'eglot-ensure)
(add-hook 'web-mode-hook 'eglot-ensure)
(add-hook 'julia-mode-hook 'eglot-ensure)

;; flycheck Settings
(require 'flycheck)
(global-flycheck-mode)
(setq flycheck-indication-mode 'left-margin)

(setq flycheck-disabled-checkers '(emacs-lisp-checkdoc))


;; Ruby Settings
(require 'ruby-mode)
(require 'rubocop)
(add-hook 'ruby-mode-hook 'rubocop-mode)
(add-hook 'ruby-mode-hook
          (lambda ()
            (setq flycheck-checker 'ruby-rubocop)))
(setq ruby-insert-encoding-magic-comment nil)

;; Rspec Settings
(require 'rspec-mode)
(setq rspec-spec-command "bin/docker/rspec")
(setq rspec-use-bundler-when-possible nil)
(setq rspec-use-relative-path t)

;; git-gutter Settings
(require 'git-gutter)
(global-git-gutter-mode)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[tj]sx?\\'" . web-mode))

(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; web-mode Settings
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(add-to-list 'eglot-server-programs
             '(web-mode . ("typescript-language-server" "--stdio")))

;; TypeScript Lint Settings
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (tide-setup))))

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "ts" (file-name-extension buffer-file-name))
              (tide-setup))))

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "vue" (file-name-extension buffer-file-name))
              (tide-setup))))

(flycheck-add-mode 'typescript-tslint 'web-mode)

;; json-mode Settings
(require 'json-mode)
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(setq json-reformat:indent-width 2)
(setq js-indent-level 2)


;; [s]css-mode Settings
(require 'css-mode)
(setq css-indent-offset 2)


;; julia-mode Settings
(require 'julia-mode)
(require 'julia-repl)
(add-hook 'julia-mode-hook 'julia-repl-mode)
(add-to-list 'eglot-server-programs
             '(julia-mode . ("julia" "-e using LanguageServer, LanguageServer.SymbolServer; runserver()")))
(define-key julia-mode-map (kbd "C-c e") 'julia-repl-send-region-or-line)

;;; init.el ends here
