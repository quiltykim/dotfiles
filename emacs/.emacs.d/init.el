(require 'package)



(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.vue$" . web-mode))

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



(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; ;; themes
(load-theme 'solarized t)
(set-frame-parameter nil 'background-mode 'dark)
(set-terminal-parameter nil 'background-mode 'dark)
(enable-theme 'solarized)


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
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(electric-indent-mode nil)
 '(electric-pair-mode t)
 '(emmet-preview-default t)
 '(global-company-mode t)
 '(global-nlinum-relative-mode t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(package-selected-packages
   (quote
    (sass-mode pug-mode haskell-mode tuareg merlin lua-mode flycheck ng2-mode smart-mode-line-powerline-theme emmet-mode company-jedi evil-commentary prettier-js smart-mode-line dockerfile-mode go-mode yaml-mode php-mode vue-mode elpy company auto-complete evil-magit web-mode magit multi-term fic-mode rjsx-mode nyan-mode nlinum-relative evil)))
 '(pug-tab-width 2)
 '(python-indent-offset 2)
 '(tide-format-options nil)
 '(typescript-indent-level 2)
 '(web-mode-code-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; THIS IS THE PART THAT WILL CHECK FOR UNINSTALLED PACKAGES AND INSTALL THEM!!!!

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

;;; flycheck-config.el --- My personal Flycheck Config File

;;; Commentary:
;; Flycheck specific configs

;;; Code:

(use-package flycheck
  :defer t
  :init
  (defun turn-on-flycheck ()
    "Force enables flycheck."
    (interactive)
    (flycheck-mode 1))
  ;; turn on flycheck mode
  (add-hook 'prog-mode-hook #'turn-on-flycheck)
  (add-hook 'yaml-mode-hook #'turn-on-flycheck)

  :config
  (setq flycheck-idle-change-delay 1.5
        flycheck-highlighting-mode 'lines)

  (flycheck-add-mode 'html-tidy 'web-mode)
  (flycheck-add-mode 'javascript-eslint 'rjsx-mode)
  ;; Use current Emacs load path
  (setq-default flycheck-emacs-lisp-load-path 'inherit)

  (add-hook 'c++-mode-hook
	          (lambda ()
		          ;; Make sure we're building with cpp 14
		          (setq flycheck-gcc-language-standard "c++14"
			              flycheck-clang-language-standard "c++14")))


  ;; Set flycheck to use pylint3 when possible
  (when (executable-find "pylint3")
    (setq flycheck-python-pylint-executable "pylint3"))
  (flycheck-add-next-checker 'python-flake8 'python-pylint)

  ;; Don't check on a newline
  (setq flycheck-check-syntax-automatically
        (delete 'new-line flycheck-check-syntax-automatically)))


;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
;;; flycheck-config.el ends here


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

(use-package emmet-mode
  :ensure t
  :commands emmet-mode)

(use-package rjsx-mode
  :ensure t
  ;; disabled js2-mode for rjsx-mode
  :mode "\\.jsx?\\'"
  :config
  (defun rjsx-mode-config ()
    "Configure RJSX Mode"
    (define-key rjsx-mode-map (kbd "C-j") 'rjsx-delete-creates-full-tag))
  (add-hook 'rjsx-mode-hook 'rjsx-mode-config))

;; (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

(use-package typescript-mode
  :ensure t
  :mode "\\.tsx?\\'"
)
(use-package tide
  :config
(setq tide-format-options '(:indentSize 2))
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))


;;; Web mode:
(use-package web-mode
  :init
  (add-hook 'web-mode-hook
            (lambda ()
              (setq web-mode-style-padding 2)
              ;; (yas-minor-mode t)
              (emmet-mode)
              (flycheck-mode))))

(use-package prettier-js
  :init
  (add-hook 'rjsx-mode-hook 'prettier-js-mode))
;;; Vue mode
;; TODO finish block
;; (use-package vue-mode
;;   :mode "\\.vue\\'"
;;   :ensure t
;;   )

;;; Angular2 mode
;; (use-package ng2-mode
;;   :ensure t
;;   :mode "\\.ts\\'"
;; )

(load "/home/qkay/.opam/4.06.0/share/emacs/site-lisp/tuareg-site-file")

;; haskell mode
(use-package haskell-mode
)

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

(use-package dockerfile-mode
  :ensure
)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;;;;; Company
(use-package company
  :diminish (company-mode . "com")
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-global-modes '(not erc-mode)))
(use-package company-jedi
  :after company
  :config
  (defun jay/python-mode-hook ()
    (add-to-list 'company-backends 'company-jedi))
  (add-hook 'python-mode-hook 'jay/python-mode-hook)
  ;; Use python3 by default!
  (when (executable-find "python3")
    (setq jedi:environment-root "jedi-python3")
    (setq jedi:environment-virtualenv
          (append python-environment-virtualenv
                  `("--python" ,(executable-find "python3"))))))

;;;;; Time
(use-package time
  :config
  (display-time-mode t)
  (setq display-time-mail-string ""))

;; no scrollbar
(when window-system
  (scroll-bar-mode -1)
  (when (boundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode -1)))

;; Titlebar
(setq frame-title-format "'nothing to see' - %b")

;;;;; Modeline

(use-package smart-mode-line
  :init
  (setq
   sml/no-confirm-load-theme t
   powerline-arrow-shape 'curve
   powerline-default-separator-dir '(right . left)

   sml/theme 'respectful
   column-number-mode t
   ;; settings might cause memory issues
   sml/shorten-directory t
   sml/shorten-modes nil
   sml/name-width 20
   sml/mode-width 'full)
  :config
  (custom-set-faces)
  (sml/setup)
  (add-to-list 'sml/replacer-regexp-list '("^~/dotfiles/emacs/\\.emacs\\.d/" ":JED:")))

(use-package smart-mode-line-powerline-theme :defer t)

(use-package nyan-mode
  :config
  (setq nyan-bar-length 20)
  (nyan-mode 1))

;;;; end modeline
