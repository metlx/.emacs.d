;;; --- 1. STARTUP OPTIMIZATION ---
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
  (lambda () 
    (setq gc-cons-threshold 800000 
          gc-cons-percentage 0.1)))

;;; --- 2. THE DEBLOAT (Refined) ---
(setq inhibit-startup-screen t
      initial-scratch-message ""
      use-file-dialog nil
      use-dialog-box nil
      inhibit-compacting-font-caches t)

;;; --- 3. PACKAGE SETUP (Faster) ---
(setq package-enable-at-startup nil)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Use-package configuration
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t
      use-package-always-defer t) ; This makes everything "Lazy" by default

;;; --- 4. CORE SETTINGS ---
(setq-default 
 make-backup-files nil 
 auto-save-default nil
 ring-bell-function 'ignore
 scroll-conservatively 101)

(cua-mode t)
(recentf-mode 1)
(save-place-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(fido-vertical-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)

;;; --- 5. THEME & VISUALS ---
(use-package modus-themes
  :ensure t
  :init
  ;; 1. Set Prot's specific overrides first
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-common-palette-overrides
        '((bg-mode-line-active "#121212")      ; Subtle dark grey for active bar
          (fg-mode-line-active "#ffffff")      ; Pure white text for active bar
          (bg-mode-line-inactive "#000000")    ; Pure black for inactive bars
          (border-mode-line-active unspecified))) ; Removes the "box" border

  ;; 2. Load the theme
  (load-theme 'modus-vivendi :no-confirm)

  :config
  ;; 3. Apply OLED black to the main window background
  (set-face-background 'default "#000000")
  
  ;; 4. Set your font
  (set-face-attribute 'default nil :font "Cascadia Code" :height 120))

;;; --- 6. LAZY LOADED TOOLS ---
(use-package which-key :init (which-key-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :custom
  (company-idle-delay 0.0) ; Instant completion
  (company-minimum-prefix-length 1))

;; Built-in Python speed
(use-package python
  :interpreter ("python" . python-mode)
  :config
  (setq python-shell-interpreter "python"))

(use-package eglot
  :hook (python-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-ignored-server-capabilities :hoverProvider))

;;; --- 7. SMART FUNCTIONS ---
(global-set-key (kbd "C-x C-r") 
  (lambda () (interactive) (find-file (completing-read "Recent: " recentf-list))))

(global-set-key (kbd "C-x k") 'kill-current-buffer)

(defun meta/run-python ()
  (interactive)
  (save-buffer)
  (compile (format "python %s" (file-name-nondirectory buffer-file-name))))
(global-set-key (kbd "<f5>") 'meta/run-python)

;; Clear clutter with Escape
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

 ;; custom-set-variables was added by Custom.
(custom-set-variables
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
