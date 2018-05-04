;;; General Tweaks
(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode 0)
(server-start)

;;; Backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

;;; Desktop
(desktop-save-mode 1)

;;; Custom Scripts
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "065efdd71e6d1502877fd5621b984cded01717930639ded0e569e1724d058af8" default)))
 '(package-selected-packages
   (quote
    (markdown-mode+ magit-filenotify docker-compose-mode docker xref-js2 js2-refactor indium flycheck-rtags flycheck ivy-rtags rtags auctex magit php-mode php+-mode flycheck-rust avy-flycheck company racer cargo rust-mode restart-emacs nix-mode json-mode multiple-cursors swiper ivy xresources-theme powerline)))
 '(safe-local-variable-values (quote ((TeX-master . t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



;;; Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;;;; Company
(with-eval-after-load 'company
  '(progn 
     (push 'company-rtags company-backends)
     (global-company-mode)
     (global-set-key (kbd "<C-tab>") (function company-complete))
     (define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
     (define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort)))

;;;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;;;; GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

(add-hook 'gud-mode-hook
          '(lambda ()
             (global-set-key (kbd "<f7>") 'gud-next)
             (global-set-key (kbd "<f8>") 'gud-step)))

;;;; Rtags
(setq rtags-autostart-diagnostics t)
(setq rtags-completions-enabled t)
(rtags-diagnostics)
(setq rtags-display-result-backend 'ivy)

(require 'flycheck)
(require 'company)
(require 'flycheck-rtags)
(defun c++-config ()
  "For use in `c++-mode-hook'."
  (rtags-start-process-unless-running)
  (company-mode)
  (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
  (local-set-key (kbd "M-,") 'rtags-find-references-at-point)
  (local-set-key (kbd "<C-left>") 'rtags-location-stack-back)
  (local-set-key (kbd "<C-right>") 'rtags-location-stack-forward)
  (local-set-key (kbd "<C-,>") 'rtags-print-symbol-info)
  (global-set-key (kbd "<f4>") 'ff-find-other-file)
  (rtags-enable-standard-keybindings)

  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil)
  (flycheck-mode)
  )

(add-hook 'c-mode-hook 'c++-config)
(add-hook 'c++-mode-hook 'c++-config)

;;;; MC
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;;; Ivy
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)

;;;; Rust
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))

;;;;; Racer
(setq racer-cmd "racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "~/Documents/Projects/Rust") ;; Rust source code PATH

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
;;(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;;; JavasScipt
(require 'js2-refactor)
(require 'xref-js2)(add-hook 'js2-mode-hook #'js2-refactor-mode)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
			   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;;; Ricing
;;(require 'xresources-theme)
(load-theme 'solarized t)
(powerline-default-theme)

