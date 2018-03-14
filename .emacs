;; Setup package.el                                                                           
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; read .bashrc se we don't have to define PATH variables in multiple places
(setenv "PATH" (shell-command-to-string "source ~/.bashrc; echo -n $PATH"))

;; UI tweaks
(customize-set-variable 'custom-enabled-themes '(tango-dark))
(setq column-number-mode t)

;; Don't pollute every folder with backup files
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

;; Packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
    (package-install 'use-package))
(use-package company
 :ensure t
   :bind (("C-c -". company-complete))
  :config
 (global-company-mode))
(use-package which-key
  :ensure t)
(use-package cider
  :ensure t)
(use-package clojure-mode
  :ensure t)
(use-package json-mode
  :ensure t)
(use-package flylisp
  :ensure t)
(use-package groovy-mode
  :ensure t)
(use-package go-mode
  :ensure t)
(use-package company-go
  :ensure t)
(use-package vue-mode
  :ensure t)
(use-package vue-html-mode
  :ensure t)
(use-package epg
  :ensure t)
(use-package yaml-mode
  :ensure t)
(use-package plantuml-mode
  :ensure t)

(epa-file-enable)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (groovy-mode flylisp json-mode cider which-key use-package company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Golang shit
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook
	  (lambda ()
	    (set (make-local-variable 'company-backends) '(company-go))
	    (company-mode)))

;; eshell-tomfoolery
(defun eshell-here ()
    "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
    (interactive)
    (let* ((parent (if (buffer-file-name)
		       (file-name-directory (buffer-file-name))
		     default-directory))
	   (height (/ (window-total-height) 3))
	   (name   (car (last (split-string parent "/" t)))))
      (split-window-vertically (- height))
      (other-window 1)
      (eshell "new")
      (rename-buffer (concat "*eshell: " name "*"))

      (insert (concat "ls"))
      (eshell-send-input)))
(global-set-key (kbd "C-c !") 'eshell-here)
(defun eshell/x ()
  (insert "exit")
  (eshell-send-input)
  (delete-window))

(setenv "PAGER" "cat")

;; Tilde does not work everywhere
(require 'iso-transl)
