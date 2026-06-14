;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-
;;; Commentary: Runs before init.el; defers package.el initialization to init.el

;;; Code:

;; init.el 内で明示的に package-initialize するため、起動時の自動初期化を抑制する
(setq package-enable-at-startup nil)

;;; early-init.el ends here
