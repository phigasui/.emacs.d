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


;;;; design ;;;;
(set-face-background 'region "#DDD")

;; (require 'cl)
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

;; rubikitch
;; auto-install.elの設定
(add-to-list 'load-path "~/.emacs.d/auto-install")
(require 'auto-install)
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)
;; (setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; 試行錯誤用ファイルを開くための設定
(require 'open-junk-file)
;; C-x C-zで試行錯誤ファイルを開く
(global-set-key (kbd "C-x C-z") 'open-junk-file)
;; 式の評価結果を注釈するための設定
;; (require 'lispxmp)
;; emacs-lisp-modeでC-c C-dを押すと注釈される
;; (define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)
;; 括弧の対応を保持して編集する設定
;; (require 'paredit)
;; (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
;; (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
;; (add-hook 'lisp-mode-hook 'enable-paredit-mode)
;; (add-hook 'ielm-mode-hook 'enable-paredit-mode)
(require 'auto-async-byte-compile)
;; 自動バイトコンパイルを無効にするファイル名の正規表現
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
;; (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
;; (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
;; (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
;; (setq eldoc-idle-delay 0.2) すぐに表示したい
;; (setq eldoc-minor-mode-string "") モードラインにElDocと表示しない

;; find-functionをキー割り当てする
;; (find-function-setup-keys)

;; (package-refresh-contents)
