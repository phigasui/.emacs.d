(add-to-list 'load-path "~/.emacs.d/elisp")

;; ELPA/Marmalade/MELPAパッケージの設定
(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (setq url-http-attempt-keepalives nil) ;;To fix MELPA problem.

;;;; function ;;;;
(defun electric-pair ()
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))

(defun insert-env ()
  (interactive)
  (insert "#! /usr/bin/env "))

(defmacro define-keys (mode-map &rest body)
  `(progn
     ,@(mapcar #'(lambda (arg)
                   `(define-key ,mode-map ,@arg)) body)))


;;;; face ;;;;
(require 'volatile-highlights)
(volatile-highlights-mode t)
(global-hl-line-mode t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "color-19" :foreground "unspecified-fg" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "default"))))
 '(bold ((t (:foreground "brightred"))))
 '(buffer-menu-buffer ((t (:background "brightcyan" :distant-foreground "brightwhite"))))
 '(hl-line ((t (:background "color-20"))))
 '(link ((t (:foreground "brightgreen" :underline t))))
 '(linum ((t (:inherit default))))
 '(minibuffer-prompt ((t (:foreground "brightwhite"))))
 '(mode-line ((t (:background "brightcyan" :foreground "black"))))
 '(region ((t (:background "color-21"))))
 '(tooltip ((t (:inherit variable-pitch :background "brightyellow" :foreground "black"))))
 '(vhl/default-face ((t (:background "color-33"))))
 '(wb-line-number-face ((t (:foreground "color-21")))))

(require 'whitespace)
(global-whitespace-mode t)
(setq whitespace-display-mappings
      '((space-mark ?\ [?\ ])
        (newline-mark ?\n [?\n])))

(setq whitespace-action '(auto-cleanup))
(setq whitespace-space-regexp "\\(\u3000\\)")
(set-face-background 'whitespace-space "red")
(set-face-background 'whitespace-tab "yellow")

(require 'linum)
(global-linum-mode t)
(setq linum-format "%5d |")


;;;; keybinds ;;;;
(define-keys global-map
  ("\C-m" 'newline-and-indent)
  ("\C-h" 'delete-backward-char)
  ("\M-?" 'help-for-help)
  ("\C-c;" 'comment-region)
  ("\C-c:" 'uncomment-region)
  ("\C-xg" 'goto-line)
  ("\C-ce" 'insert-env))

;;;; other conf ;;;;
(setq-default tab-width 4 indent-tabs-mode nil)
(show-paren-mode t)
(setq delete-auto-save-files t)
(which-function-mode t)
(line-number-mode t)
(column-number-mode t)
(setq fill-column 79)
(setq backup-inhibited t)

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
(ac-config-default)
(setq ac-comphist-file "~/.emacs.d/cache/auto-complete/ac-comphist.dat")


;;;; extends ;;;;
(setq auto-mode-alist
      (cons (cons "\\.pjs$" 'java-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons (cons "\\.pde$" 'java-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons (cons "\\.dart$" 'java-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons (cons "\\.cmm$" 'c-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons (cons "\\.m$" 'octave-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons (cons "\\.wsgi$" 'python-mode) auto-mode-alist))


;;;; python ;;;;
(defun py-main ()
  (interactive)
  (insert "if __name__ == '__main__':")
  (newline-and-indent))

(add-hook
 'python-mode-hook
 '(lambda()
    (define-key python-mode-map "\C-cm" 'py-main)
    ;; (define-key python-mode-map "\"" 'electric-pair)
    ;; (define-key python-mode-map "\'" 'electric-pair)
    ;; (define-key python-mode-map "[" 'electric-pair)
    ;; (define-key python-mode-map "{" 'electric-pair)
    ;; (define-key python-mode-map "(" 'electric-pair)
    ))


(add-to-list 'load-path "~/.emacs.d/emacs-swoop")
(require 'swoop)
(global-set-key (kbd "C-c o") 'swoop)

(add-to-list 'load-path "~/.emacs.d/auto-install")
(require 'open-junk-file)
(global-set-key (kbd "C-x C-z") 'open-junk-file)

(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-linum-mode t)
 '(linum-format "%5d |"))
