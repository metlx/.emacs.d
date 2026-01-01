;;; --- 1. THE STARTUP TURBO (Maximum Speed) ---
(setq gc-cons-threshold most-positive-fixnum 
      gc-cons-percentage 0.6
      read-process-output-max (* 1024 1024)
      frame-inhibit-implied-resize t)

;; Reset GC after 5 seconds of idle time to keep startup instant
(add-hook 'emacs-startup-hook
          (lambda () (run-with-idle-timer 5 nil (lambda () (setq gc-cons-threshold 800000)))))

;;; --- 2. THE META DEBLOAT (Zero-UI / Total Darkness) ---
(setq inhibit-startup-screen nil   ; KEEP the logo
      initial-scratch-message ""   ; Clear background text
      frame-title-format ""        ; Clear window title
      mode-line-format nil         ; META: Kill the bottom status bar
      use-file-dialog nil
      inhibit-compacting-font-caches t)

;; Massive UI shutdown
(mapc (lambda (mode) (when (fboundp mode) (funcall mode -1)))
      '(menu-bar-mode tool-bar-mode scroll-bar-mode tooltip-mode))

;; Early frame settings to prevent "flashing" white bars
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;;; --- 3. PACKAGE & NATIVE COMP ENGINE ---
(setq comp-deferred-compilation nil
      package-enable-at-startup nil
      package-quickstart nil)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;; --- 4. CORE SETTINGS & LATENCY FIX ---
(setq make-backup-files nil auto-save-default nil
      ring-bell-function 'ignore
      scroll-step 1 scroll-conservatively 10000
      idle-update-delay 1.0
      w32-get-true-pixel-density t)

(setq-default cursor-type 'bar)
(cua-mode t)          ; Standard Ctrl+C/V for your remapped Caps Lock
(recentf-mode 1)
(save-place-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(fido-vertical-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

;; Load the best built-in dark theme
(load-theme 'modus-vivendi t)
;; OPTIONAL: If you want the background to be TRULY black (OLED style)
;; instead of the default dark navy/grey of Modus Vivendi:
(set-face-background 'default "#000000")
(set-face-background 'mode-line "#1e1e1e") ; Subtle dark bar
(set-face-foreground 'mode-line "#ffffff") ; White text on bar
(set-face-attribute 'default nil :font "Cascadia Code" :height 120)

;;; --- 5. LAZY-LOADED IDE FEATURES ---
(use-package which-key :config (which-key-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :custom
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 2))

(use-package tree-sitter
  :hook (python-mode . tree-sitter-hl-mode)
  :config (global-tree-sitter-mode))

(use-package tree-sitter-langs :after tree-sitter)

(use-package eglot
  :defer t
  :hook (python-mode . eglot-ensure)
  :custom (eglot-ignored-server-capabilities '(:hoverProvider)))

(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))

;;; --- 6. CUSTOM SMART FUNCTIONS ---
(defun fido-recentf-open ()
  "Fastest file switching."
  (interactive)
  (find-file (completing-read "Find recent file: " recentf-list)))
(global-set-key (kbd "C-x C-r") 'fido-recentf-open)

(defun custom/kill-this-buffer () 
  "Quick-scope buffer."
  (interactive) (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'custom/kill-this-buffer)

(defun meta/run-python ()
  "Save the buffer and run the current python file."
  (interactive)
  (save-buffer)
  (compile (format "python %s" (file-name-nondirectory buffer-file-name))))

;; Bind it to F5 (a classic coder shortcut)
(global-set-key (kbd "<f5>") 'meta/run-python)

(defun meta/kill-extra-windows ()
  "Kill the compilation buffer and reset to a single window layout."
  (interactive)
  (let ((comp-buf (get-buffer "*compilation*")))
    (when comp-buf
      (kill-buffer comp-buf)))
  (delete-other-windows) ; This forces the 'Total Darkness' single-pane look
  (message "Windows cleared."))

;; Bind it to C-g
(global-set-key (kbd "C-g") 'meta/kill-extra-windows)







;; custom stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
