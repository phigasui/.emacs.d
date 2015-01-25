(setq load-path (append
                 '("~/.emacs.d/elisp")
                 load-path))


;;;; function ;;;;
(defun electric-pair ()
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))

;; (defun insert-env (env)
;;   (interactive "sexec-env: ")
;;   (insert (concat "#! " (shell-command-to-string (concat "which " env)) "\n")))

(defun insert-env ()
  (interactive)
  (insert "#! /usr/bin/env "))

(defmacro define-keys (mode-map &rest body)
  `(progn
     ,@(mapcar #'(lambda (arg)
                   `(define-key ,mode-map ,@arg)) body)))


;;;; design ;;;;
(set-face-background 'region "#DDD")

(require 'cl)
(global-whitespace-mode t)
(setq whitespace-display-mappings
      '((space-mark ?\ [?\ ])
        (newline-mark ?\n [?\n])))
(set-face-background 'whitespace-space "#8A8A8A")

(setq backup-inhibited t)
(defface hlline-face
  '((((class color)
      (background dart))
     (:background "#aaa"))
    (((class color)
      (background light))
     (:background "#999"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode t)

(require 'wb-line-number)
(wb-line-number-toggle)
(custom-set-faces
 '(wb-line-number-face
   ((t
     (:foreground "#333"))))
 ;; '(wb-line-number-scroll-bar-face
 ;;   ((t
 ;;     (:foreground "red" :bakground "red"))))
 )


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


;;;; python ;;;;
(defun py-main ()
  (interactive)
  (insert "if __name__ == '__main__':")
  (newline-and-indent))

(add-hook
 'python-mode-hook
 '(lambda()
    (define-key python-mode-map "\C-cm" 'py-main)
    (define-key python-mode-map "\"" 'electric-pair)
    (define-key python-mode-map "\'" 'electric-pair)
    (define-key python-mode-map "[" 'electric-pair)
    (define-key python-mode-map "{" 'electric-pair)
    (define-key python-mode-map "(" 'electric-pair)))
