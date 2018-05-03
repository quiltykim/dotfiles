(require 'package)



(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; We want to track if we've run a refresh this time
(setq belak/did-refresh nil)
;; Small function to install a missing package
(defun package-ensure-installed (package)
  (unless (package-installed-p package)
    (unless belak/did-refresh
      (package-refresh-contents)
      (setq belak/did-refresh t))
    (package-install package)))

(package-ensure-installed 'use-package)



;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; ;; themes
;; (load-theme 'solarized t)
;; (set-frame-parameter nil 'background-mode 'dark)
;; (set-terminal-parameter nil 'background-mode 'dark)
;; (enable-theme 'solarized)


;; Toolbars
(when window-system
  (tool-bar-mode -1))
(menu-bar-mode -1)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-minimum-prefix-length 2)
 '(electric-indent-mode nil)
 '(electric-pair-mode t)
 '(emmet-preview-default t)
 '(global-company-mode t)
 '(global-nlinum-relative-mode t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(package-selected-packages
   (quote
    (evil-commentary prettier-js smart-mode-line dockerfile-mode go-mode yaml-mode php-mode vue-mode elpy company auto-complete evil-magit web-mode magit multi-term fic-mode rjsx-mode nyan-mode nlinum-relative evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; THIS IS THE PART THAT WILL CHECK FOR UNINSTALLED PACKAGES AND INSTALL THEM!!!!

;; Define functions
(defun jay/install-unless-present (package)
  "Install PACKAGE unless it's present already.
PACKAGE is a symbol"
  (unless (require package nil 'noerror)
    (package-install package)
    (require package)))
(defun jay/early-install ()
  "Installation of very early packages we absolutely need."
  (jay/install-unless-present 'use-package))
;; Call functions
(jay/early-install)

(require 'use-package)
;;;; Package Definitions
;;;;; Use Package
(use-package use-package
  :config
  (setq use-package-always-ensure t))

(use-package evil
  ;; Init will run immediately, :config will run after load
  :init
  (evil-mode 1))


(use-package evil-commentary
  :init
  (evil-commentary-mode))

(use-package nlinum-relative
  :init
  (nlinum-relative-setup-evil)                    ;; setup for evil - that is, absolute numbering in insert mode
  )


;; powerline configs
(use-package smart-mode-line
  :config
  (setq
   sml/no-confirm-load-theme t
   powerline-arrow-shape 'curve
   powerline-default-separator-dir '(right . left)

   sml/theme 'respectful
   column-number-mode t
   ;; These seem to cause memory issues...
   sml/shorten-directory nil
   sml/shorten-modes nil
   sml/name-width 20
   sml/mode-width 'full
   nyan-bar-length 20))

(use-package nyan-mode
  :init
  (nyan-mode 1))

;; Term config
(use-package multi-term

  :config
  (setq multi-term-program "/bin/bash"
        multi-term-scroll-to-bottom-on-output t)
  (add-to-list 'term-bind-key-alist '("<ESC> <ESC>" . term-send-esc)))

;; Turn on TODO highlighting
(use-package fic-mode
  :init
  (add-hook 'prog-mode-hook 'fic-mode))

;;; For switching windows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; IDO is builtin, we don't have to use use-package, but we can if we wish
(require 'ido)
(ido-mode t)

(use-package rjsx-mode
  :ensure t
  ;; disabled js2-mode for rjsx-mode
  :mode "\\.js\\'"
  :config
  (defun rjsx-mode-config ()
    "Configure RJSX Mode"
    (define-key rjsx-mode-map (kbd "C-j") 'rjsx-delete-creates-full-tag))
  (add-hook 'rjsx-mode-hook 'rjsx-mode-config))
;; (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

(use-package prettier-js
  :init
  (add-hook 'rjsx-mode-hook 'prettier-js-mode))


;;; Web mode:
(use-package web-mode
  :init
  (add-hook 'web-mode-hook
            (lambda ()
              (setq web-mode-style-padding 2)
              ;; (yas-minor-mode t)
              (emmet-mode)
              (flycheck-add-mode 'html-tidy 'web-mode)
              (flycheck-mode))))

;;; Vue mode
;; TODO finish block
;; (use-package vue-mode
;;   :mode "\\.vue\\'"
;;   )

(setq scroll-step 1
      auto-window-vscroll nil
      scroll-conservatively 10000
      scroll-margin 0
      ;; scroll-up-aggressively 0.01
      ;; scroll-down-aggressively 0.01
      mouse-wheel-progressive-speed nil)

;; builtin, don't have to use use-package (but we can)
(require 'desktop)
(desktop-save-mode 1)

;; Autosave after 30s
;; Don't run if desktop-save-mode is not true
(defvar my-desktop-autosave-timer (not desktop-save-mode))
(unless my-desktop-autosave-timer
  (setq my-desktop-autosave-timer
        (run-with-idle-timer 30 nil
                             #'desktop-auto-save)))
(use-package evil-magit
  :after evil
  :init
  ;; custom keybindings
  (global-set-key (kbd "C-j") 'emmet-expand-line)
  (global-set-key (kbd "C-x g") 'magit-status))

(cond
 ((find-font (font-spec :name "Monoid"))
  (set-frame-font "Monoid-9" nil t))
 ((find-font (font-spec :name "DejaVu Sans Mono"))
  (set-frame-font "DejaVu Sans Mono-10" nil t))
 ((find-font (font-spec :name "Terminus"))
  (set-frame-font "Terminus-12" nil t))
 (t
  ;; We can't do squat
  (message "You don't have any good fonts installed!")))

