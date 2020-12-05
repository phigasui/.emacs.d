
;;; Code:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(markdown-preview-mode markdown-mode open-junk-file tide git-gutter-fringe rubocop eglot terraform-mode find-file-in-project flycheck counsel yaml-mode slim-mode magit web-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


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


;; Global Settings
(electric-pair-mode t)
(global-display-line-numbers-mode)


;; Global Key Binds
(define-key global-map (kbd "C-h" ) 'delete-backward-char)
(define-key global-map (kbd "M-x") 'counsel-M-x)
(define-key global-map (kbd "C-s") 'swiper-isearch)
(define-key global-map (kbd "C-r") 'swiper-isearch-backward)
(define-key global-map (kbd "C-c g") 'counsel-git-grep)
(define-key global-map (kbd "C-c f") 'counsel-find-file)


;; ivy Settings
(ivy-mode 1)
(setq-default ivy-use-virtual-buffers t)
(setq-default ivy-count-format "(%d/%d) ")


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

;; flycheck Settings
(require 'flycheck)
(global-flycheck-mode)
(setq flycheck-indication-mode 'left-margin)

(setq flycheck-disabled-checkers '(emacs-lisp-checkdoc))


;; Ruby Settings
(require 'rubocop)
(add-hook 'ruby-mode-hook 'rubocop-mode)
(add-hook 'ruby-mode-hook
  '(lambda ()
     (setq flycheck-checker 'ruby-rubocop)))
(setq-default ruby-insert-encoding-magic-comment nil)



;; git-gutter Settings
(require 'git-gutter)
(global-git-gutter-mode)


;; Mode List
(require 'slim-mode)
(add-to-list 'auto-mode-alist '("\\.slim\\'" . slim-mode))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[tj]sx?\\'" . web-mode))

(require 'markdown-preview-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-preview-mode))


;; web-mode Settings
(setq indent-tabs-mode nil)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)


;; TypeScript Lint Settings
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (tide-setup))))

(flycheck-add-mode 'typescript-tslint 'web-mode)

;;; init.el ends here
