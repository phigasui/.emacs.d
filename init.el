;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary: Emacs 29+ configuration

;;; Code:

;; ============================================================
;; straight.el bootstrap (copilot と prisma-mode のみ)
;; ============================================================
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
 '(copilot :type git :host github :repo "copilot-emacs/copilot.el"
           :files ("dist" "*.el")))

(straight-use-package
 '(claude-code-ide :type git :host github :repo "manzaltu/claude-code-ide.el"))

;; ============================================================
;; package.el
;; ============================================================
(require 'package)
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; 毎起動のネットワーク通信を避ける（パッケージが未インストールの時のみ取得）
(unless package-archive-contents
  (package-refresh-contents))

;; ============================================================
;; use-package (Emacs 29 組み込み)
;; ============================================================
(require 'use-package)
(setq use-package-always-ensure t)

;; ============================================================
;; exec-path-from-shell
;;   GUI (Finder/Dock) から起動した Emacs.app はシェルの PATH 等を
;;   引き継がないため、eglot が ruby-lsp を、consult-ripgrep が rg を
;;   見つけられない。シェルから環境変数を取り込んで解消する。
;;   PATH 系 (homebrew / mise / ~/.local/bin) は ~/.zshrc に書かれて
;;   いるため、ログインシェルだけでは読めない。-i を付けて
;;   インタラクティブシェルとして環境を取得する。
;; ============================================================
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :custom
  (exec-path-from-shell-arguments '("-l" "-i"))
  :config
  (dolist (var '("ANTHROPIC_API_KEY"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize)
  ;; mise の shims は `mise activate` の precmd フック経由で PATH に
  ;; 追加されるため、exec-path-from-shell では取り込めない（ruby-lsp が
  ;; 見つからない原因）。shims ディレクトリを明示的に追加する。
  ;; shim 自体がカレントディレクトリから tool のバージョンを解決するため、
  ;; static なパスを足すだけで repo ごとの ruby が選ばれる。
  (let ((mise-shims (expand-file-name "~/.local/share/mise/shims")))
    (when (file-directory-p mise-shims)
      (add-to-list 'exec-path mise-shims)
      (setenv "PATH" (concat mise-shims path-separator (getenv "PATH"))))))

;; ============================================================
;; custom.el に Custom の書き込みを分離
;; ============================================================
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file 'noerror 'nomessage))

;; ============================================================
;; グローバル基本設定
;; ============================================================
(set-language-environment "UTF-8")
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(electric-pair-mode t)
(global-display-line-numbers-mode t)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(global-set-key (kbd "s-z") #'undo)

(use-package dired
  :ensure nil
  :custom (dired-dwim-target t))

;; ============================================================
;; UI / テーマ
;; ============================================================
(use-package nerd-icons
  :ensure t)
;; 初回のみ: M-x nerd-icons-install-fonts

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one-light t)
  (doom-themes-visual-bell-config))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t))

;; ============================================================
;; ミニバッファ補完スタック (vertico + orderless + marginalia + consult + embark)
;; ============================================================
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides
   '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package consult
  :ensure t
  :bind
  (("C-s"   . consult-line)
   ("C-r"   . consult-line)
   ("C-c g" . consult-ripgrep)
   ("C-c f" . project-find-file)
   ("C-c b" . consult-buffer)
   ("C-c r" . consult-recent-file))
  )

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; ============================================================
;; バッファ内補完 (corfu + cape)
;; ============================================================
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  (corfu-quit-at-boundary nil)
  (corfu-separator ?\s)
  :bind
  (:map corfu-map
   ("C-n" . corfu-next)
   ("C-p" . corfu-previous))
  :init
  (global-corfu-mode))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;; ============================================================
;; ユーザー関数
;; ============================================================
(defun copy2clipboard ()
  "Copy region to macOS clipboard."
  (interactive)
  (when (region-active-p)
    (shell-command-on-region (region-beginning) (region-end) "pbcopy" nil nil)))

(defun sort-js-import-lines (beg end)
  "Sort JS import lines from BEG to END."
  (interactive (list (region-beginning) (region-end)))
  (sort-regexp-fields nil "^import.+$" "from.+" beg end))

(defun counter-other-window ()
  "Move focus to the previous window."
  (interactive)
  (other-window -1))

;; ============================================================
;; グローバルキーバインド
;; ============================================================
(keymap-global-set "C-h"     #'delete-backward-char)
(keymap-global-set "C-c c"   #'copy2clipboard)
(keymap-global-set "C-x O"   #'counter-other-window)
(keymap-global-set "C-c RET" #'find-file-at-point)
;; M-x は vertico が自動強化するので counsel-M-x は不要
;; C-s / C-r / C-c g / C-c f は consult の :bind で設定済み

;; ============================================================
;; whitespace-mode + highlight-indent-guides
;; ============================================================
(use-package whitespace
  :ensure nil
  :hook (prog-mode . whitespace-mode)   ; BUG FIX: was global-whitespace-mode
  :custom
  (whitespace-style '(face
                      tabs
                      trailing
                      space-before-tab
                      indentation
                      empty
                      space-after-tab
                      tab-mark)))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character))

;; ============================================================
;; ddskk (日本語入力 SKK)
;; ============================================================
(use-package ddskk
  :ensure t
  :hook (find-file . (lambda () (skk-latin-mode 1)))
  :custom
  (default-input-method "japanese-skk")
  (skk-server-host "localhost")
  (skk-server-portnum 1178)
  (skk-jisyo-code 'utf-8)
  (skk-egg-like-newline t)
  (skk-show-annotation t)
  (skk-delete-implies-kakutei nil)
  (skk-annotation-delay 0)
  (skk-show-tooltip t)
  :config
  (setq skk-rom-kana-rule-list
        (append '(("c" nil skk-abbrev-mode))
                skk-rom-kana-rule-list))
  (defconst overriding-skk-rom-kana-base-rule-list
    (seq-filter
     (lambda (x)
       (cond ((stringp (car x))
              (not (string= (substring (car x) 0 1) "c")))))
     skk-rom-kana-base-rule-list))
  (setq skk-rule-tree
        (skk-compile-rule-list
         overriding-skk-rom-kana-base-rule-list
         skk-rom-kana-rule-list)))

;; ============================================================
;; バージョン管理 (magit + forge + git-gutter)
;; ============================================================
(use-package magit
  :ensure t
  :custom
  (magit-diff-refine-hunk t)
  (magit-display-buffer-function
   (lambda (buffer)
     (display-buffer buffer '(display-buffer-same-window)))))

(use-package forge
  :ensure t
  :after magit
  :bind
  (:map magit-mode-map
   ("C-c C-w" . forge-browse-dwim)))

(use-package git-gutter-fringe
  :ensure t
  :config
  (global-git-gutter-mode t))

;; ============================================================
;; GitHub Copilot (straight.el でインストール済み)
;; ============================================================
(use-package copilot
  :ensure nil
  :hook (prog-mode . copilot-mode)
  :bind
  (:map copilot-completion-map
   ("C-p"   . copilot-previous-completion)
   ("C-n"   . copilot-next-completion)
   ("<tab>" . copilot-accept-completion)
   ("TAB"   . copilot-accept-completion)))

;; ============================================================
;; eglot (Emacs 29 組み込み LSP クライアント)
;; ============================================================
(use-package eglot
  :ensure nil
  :config
  (add-to-list 'eglot-server-programs
               '((ruby-mode ruby-ts-mode) . ("ruby-lsp")))
  (add-to-list 'eglot-server-programs
               '((typescript-ts-mode tsx-ts-mode web-mode) . ("typescript-language-server" "--stdio")))
  ;; eglot + corfu の補完スタイル
  (setq completion-category-overrides '((eglot (styles orderless)))))

;; ============================================================
;; flycheck
;; ============================================================
(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode)
  :custom
  (flycheck-indication-mode 'left-margin)
  (flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;; ============================================================
;; treesit-auto (tree-sitter グラマー自動管理)
;; ============================================================
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; ============================================================
;; Ruby
;; ============================================================
(use-package ruby-ts-mode
  :ensure nil
  :hook
  ((ruby-ts-mode . eglot-ensure)
   (ruby-ts-mode . rubocop-mode)
   (ruby-ts-mode . (lambda ()
                     (setq flycheck-checker 'ruby-rubocop)))))

(use-package rubocop
  :ensure t)

(use-package rspec-mode
  :ensure t
  :custom
  (rspec-spec-command "bin/docker/rspec")
  (rspec-use-bundler-when-possible nil)
  (rspec-use-relative-path t))

(setq ruby-insert-encoding-magic-comment nil)

;; ============================================================
;; TypeScript / TSX (組み込み ts-mode)
;; ============================================================
(use-package typescript-ts-mode
  :ensure nil
  :hook
  ((typescript-ts-mode . eglot-ensure)
   (tsx-ts-mode        . eglot-ensure)))

;; ============================================================
;; web-mode (HTML と Vue のみ)
;; ============================================================
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.vue\\'"   . web-mode))
  :hook (web-mode . eglot-ensure)
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))

;; ============================================================
;; JSON (組み込み json-ts-mode)
;; ============================================================
(use-package json-ts-mode
  :ensure nil
  :custom (js-indent-level 2))

;; ============================================================
;; YAML (組み込み yaml-ts-mode)
;; ============================================================
(use-package yaml-ts-mode
  :ensure nil)

;; ============================================================
;; CSS / SCSS
;; ============================================================
(use-package css-mode
  :ensure nil
  :custom (css-indent-offset 2))

;; ============================================================
;; Markdown
;; ============================================================
(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")

;; ============================================================
;; ユーティリティ
;; ============================================================
(use-package string-inflection :ensure t)
(use-package multiple-cursors  :ensure t)
(use-package open-junk-file    :ensure t)
(use-package find-file-in-project :ensure t)
(use-package jest              :ensure t)
(use-package adoc-mode         :ensure t)
(use-package csv-mode          :ensure t)
(use-package sqlformat         :ensure t)

;; ============================================================
;; Claude Code / Claude API 連携
;; ============================================================

;; emacsclient が使えるようにサーバーを起動（daemon モード以外のフォールバック）
(unless (server-running-p)
  (server-start))

;; eat: ターミナルエミュレータ（claude-code-ide のバックエンド）
(use-package eat
  :ensure t)

;; vterm: claude-code-ide のデフォルトターミナルバックエンド
(use-package vterm
  :ensure t
  :custom
  ;; C-h をグローバルで delete-backward-char にしているため、
  ;; vterm 内でもターミナルに送信されるよう exceptions から除外
  (vterm-keymap-exceptions '("C-c" "C-x" "C-u" "C-g" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y"))
  :config
  ;; exceptions だけでは反映されない場合があるため明示的にバインド
  (define-key vterm-mode-map (kbd "C-h") #'vterm--self-insert))

;; claude-code-ide: Emacs 内で Claude Code を起動（straight.el でインストール済み）
(use-package claude-code-ide
  :ensure nil
  :bind ("C-c C-c" . claude-code-ide-menu))

;; gptel: Emacs 内で Claude API を直接使う
(use-package gptel
  :ensure t
  :custom
  (gptel-model 'claude-sonnet-4-6)
  :config
  (gptel-make-anthropic "Claude"
    :stream t
    :key (lambda () (getenv "ANTHROPIC_API_KEY"))))

;;; init.el ends here
