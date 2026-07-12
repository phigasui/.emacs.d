;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-
;;; Commentary: init.el より前、最初のフレーム生成より前に実行される

;;; Code:

;; init.el 内で明示的に package-initialize するため、起動時の自動初期化を抑制する
(setq package-enable-at-startup nil)

;; 起動中は GC を実質停止し、起動完了後に現実的な値へ戻す
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)) ; 32MB
            (message "Emacs ready in %s with %d GCs"
                     (emacs-init-time) gcs-done)))

;; eglot (ruby-lsp / tsserver) のサブプロセス読み取りを高速化
(setq read-process-output-max (* 1024 1024))

;; native-comp の警告バッファをポップアップさせない
(setq native-comp-async-report-warnings-errors 'silent)

;; 最初のフレーム生成前に UI 要素を確定させ、ちらつきとリサイズを防ぐ
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(setq frame-inhibit-implied-resize t)
;; macOS のメニューバーはグローバルなので menu-bar-lines は触らない

;;; early-init.el ends here
