;;; init.el --- The "Formula 1" Config

;; 1. GC Magic: Set it high for startup, reset it to something sane later
(defun my/reset-gc ()
  (setq gc-cons-threshold 800000 
        gc-cons-percentage 0.1))
(add-hook 'emacs-startup-hook #'my/reset-gc)

;; 2. Package Engine (Optimized for speed)
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t
      use-package-always-defer t)

;; 3. Core Speed Settings (Lower Latency)
(setq-default 
 inhibit-startup-screen t
 initial-scratch-message ""
 ring-bell-function 'ignore
 scroll-conservatively 101
 fast-but-imprecise-scrolling t  ; Don't wait for perfect render when scrolling fast
 jit-lock-defer-time 0           ; Instant fontification
 idle-update-delay 1.0)          ; Don't waste CPU when I'm active

;; 4. UI/Theme (Immediate Load)
(use-package modus-themes
  :demand t ; Loaded immediately because you can't work in the dark
  :init
  (setq modus-themes-common-palette-overrides
        '((bg-mode-line-active "#121212")
          (fg-mode-line-active "#ffffff")
          (bg-mode-line-inactive "#000000")
          (border-mode-line-active unspecified)))
  :config
  (load-theme 'modus-vivendi :no-confirm)
  (set-face-background 'default "#000000")
  (set-face-attribute 'default nil :font "Cascadia Code" :height 120))

;; 5. IDE Features (Fully Lazy)
(use-package which-key :init (which-key-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1
        company-dabbrev-downcase nil)) ; Faster completion

(use-package eglot
  :hook (python-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-ignored-server-capabilities :hoverProvider)
  (setq eglot-events-buffer-size 0)) ; Speed up by not logging LSP events

;; 6. Essential Modes
(cua-mode t)
(fido-vertical-mode 1)
(recentf-mode 1)
(save-place-mode 1)

;; 7. The Global Keymap
(global-set-key (kbd "C-x C-r") 
  (lambda () (interactive) (find-file (completing-read "Recent: " recentf-list))))
(global-set-key (kbd "<f5>") 
  (lambda () (interactive) (save-buffer) 
    (compile (format "python %s" (file-name-nondirectory buffer-file-name)))))
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
