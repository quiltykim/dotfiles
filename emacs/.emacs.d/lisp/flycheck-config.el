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
  (unless (or (eq system-type 'cygwin)
              (string= (system-name) "gilly"))
    (add-hook 'prog-mode-hook #'turn-on-flycheck)
    (add-hook 'yaml-mode-hook #'turn-on-flycheck))

  :config
  (setq flycheck-idle-change-delay 1.5
        flycheck-highlighting-mode 'lines)

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

;; (use-package flycheck-clojure
;;   :defer t
;;   :commands clojure-mode
;;   :config
;;   (flycheck-clojure-setup))
;; (use-package flycheck-rust
;;   :defer t
;;   :commands rust-mode
;;   :config
;;   (flycheck-rust-setup))

;; (use-package flycheck-mypy
;;   :defer t
;;   :commands flycheck
;;   (flycheck-add-next-checker 'python-pylint 'python-mypy)
;;   ;; Don't complain about missing arguments in flycheck
;;   (setq flycheck-python-mypy-args "--ignore-missing-imports"))

(provide 'flycheck-config)

;;; flycheck-config.el ends here
