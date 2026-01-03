;;; early-init.el --- Maximum Speed Pre-Boot
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Disable UI instantly to prevent rendering lag
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(setq-default frame-inhibit-implied-resize t)

;; Prevent package.el from slowing down startup
(setq package-enable-at-startup nil)
