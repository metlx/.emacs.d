;; ricky bobby
(setq gc-cons-threshold 100000000)
(setq idle-update-delay 0.1)

;; use package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; plugins
(use-package vertico
  :init
  (vertico-mode))

;; (use-package ef-themes
;;   :config
;;   (load-theme 'ef-dark t))

(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  :init
  (global-corfu-mode))

(use-package treesit
  :ensure nil
  :config
  (setq treesit-language-source-alist
        '((python "https://github.com/tree-sitter/tree-sitter-python"))))

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :config
  (setq python-indent-offset 4))

(use-package eglot
  :ensure nil
  :config
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
  :hook (python-ts-mode . eglot-ensure))

;; ui
(setq ring-bell-function 'ignore)
(tool-bar-mode -1)
(menu-bar-mode -1)
(electric-pair-mode 1)
(scroll-bar-mode -1)
(set-fringe-mode 10)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq scroll-step 1
      scroll-conservatively 10000)
(savehist-mode 1)
(save-place-mode 1)
(set-charset-priority 'unicode)
(setq treesit-font-lock-level 4)
(setq-default cursor-type 'bar)
(show-paren-mode 1)
(setq show-paren-delay 0)
(require 'recentf)
(setq recentf-max-saved-items 30)
(recentf-mode 1)
(add-hook 'buffer-list-update-hook 'recentf-track-opened-file)
(global-set-key (kbd "C-x C-r") 'recentf-open)
(setq inhibit-startup-screen t)
(setq initial-buffer-choice t)
