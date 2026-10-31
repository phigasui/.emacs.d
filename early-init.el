;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-
;;; Commentary: init.el より前、最初のフレーム生成より前に実行される

;;; Code:

;; init.el 内で明示的に package-initialize するため、起動時の自動初期化を抑制する
(setq package-enable-at-startup nil)

;; 起動中は GC を実質停止し、起動完了後に現実的な値へ戻す
(setq gc-cons-threshold most-positive-fixnum)

;; 起動中の正規表現マッチを抑制するため、file-name-handler-alist を一時退避する
(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)) ; 32MB
            (setq file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       default-file-name-handler-alist)))
            (message "Emacs ready in %s with %d GCs"
                     (emacs-init-time) gcs-done)))

;; eglot (ruby-lsp / tsserver) のサブプロセス読み取りを高速化
(setq read-process-output-max (* 1024 1024))

;; native-comp の警告バッファをポップアップさせない
(setq native-comp-async-report-warnings-errors 'silent)

;; Emacs.app 同梱の libgccjit (GCC 14) は macOS 27 で -mmacosx-version-min=18.0 を渡し、
;; clang がそれを拒否して native-comp が全滅する (GCC 16 の gcc では 27.0 が渡る)。
;; sw_vers の実際の版を明示する。同梱 libgccjit が更新されたら外す
(when (eq system-type 'darwin)
  (defvar native-comp-driver-options)
  (with-eval-after-load 'comp
    (let ((macos (string-to-number (car (process-lines "sw_vers" "-productVersion")))))
      (when (>= macos 26)
        (add-to-list 'native-comp-driver-options
                     (format "-mmacosx-version-min=%d.0" macos) t)))))

;; 最初のフレーム生成前に UI 要素を確定させ、ちらつきとリサイズを防ぐ
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(setq frame-inhibit-implied-resize t)
;; macOS のメニューバーはグローバルなので menu-bar-lines は触らない

;;; early-init.el ends here
