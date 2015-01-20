(setq load-path (append
                 '("~/.emacs.d/elisp")
                 load-path))

;;;; design
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


;;;; keybinds:
(defmacro define-keys (mode-map &rest body)
  `(progn
     ,@(mapcar #'(lambda (arg)
                   `(define-key ,mode-map ,@arg)) body)))
(define-keys global-map
  ("\C-m" 'newline-and-indent)
  ("\C-h" 'delete-backward-char)
  ("\M-?" 'help-for-help)
  ("\C-c;" 'comment-region)
  ("\C-c:" 'uncomment-region)
  ("\C-xg" 'goto-line))


(setq-default tab-width 4 indent-tabs-mode nil)
(show-paren-mode 1)
(setq delete-auto-save-files t)

;; (require 'web-mode)
;; (defalias 'prog-mode 'fundamental-mod)
;; (add-to-list 'auto-mode-alist'("\\.html?\\'" .web-mode))

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

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

(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
(ac-config-default)

;; (require 'python)

;; (require 'ac-python)
;; (add-to-list 'ac-modes 'python-2-mode)

;; (setq ac-use-menu-map t)
;; (define-key ac-menu-map "\C-n" 'ac-next)
;; (define-key ac-menu-map "\C-p" 'ac-previous)

;; (defun py-main ()
;;   (interactive)
;;   (insert "if __name__ == '__main__':\n    "))

;; (defun my-short-buffer-file-coding-system (&optional default-coding)
;;   (let ((coding-str (format "%S" buffer-file-coding-system)))
;;     (cond ((string-match "utf-8" coding-str) 'utf-8)
;;           (t (or default-coding 'utf-8)))))

;; (defun my-insert-file-local-coding ()
;;   (interactive)
;;   (save-excursion
;;     (goto-line 2) (end-of-line)
;;     (let ((limit (point)))
;;       (goto-char (point-min))
;;       (unless (search-forward "coding:" limit t)
;;         (goto-char (point-min))

;;         (when (and (< (+ 2 (point-min)) (point-max))
;;                    (string= (buffer-substring (point-min) (+ 2 (point-min))) "#!"))
;;           (unless (search-forward "\n" nil t)
;;             (insert "\n")))
;;         (let ((st (point)))
;;           (insert (format "! /opt/local/bin/python\n# coding : utf-8\n" (my-short-buffer-file-coding-system)))
;;           (comment-region st (point)))))))

;; (add-hook 'python-mode-hook 'my-insert-file-local-coding)


;; processing
;; (defun open-current-buffer-file ()
;;   (shell-command (format "open %s" (buffer-file-name (current-buffer)))))

;; (defun run-apple-script ()
;;   (shell-command-to-string (format "/usr/bin/osascript -e '%s' &" apple-script-code)))

;; (defvar apple-script-code"
;; tell application \"Processing\"
;; activate
;; end tell

;; tell application \"System Events\"
;; if UI elements enabled then
;; key down command
;; keystroke \"r\"
;; key up command
;; end if
;; end tell
;; ")

(require 'package)
(add-to-list 'package-archives
         '("marmalade" .
           "http://marmalade-repo.org/packages/"))

(which-function-mode 1)
(menu-bar-mode nil)
