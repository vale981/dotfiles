;;; General Tweaks
(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
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

;;; Custom Scriptsp
(defun close-all-buffers ()
(interactive)
  (mapc 'kill-buffer (buffer-list)))

;;; Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

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

;;; Ricing
;;(require 'xresources-theme)
(load-theme 'solarized t)
(powerline-default-theme)

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
    (json-mode multiple-cursors swiper ivy xresources-theme powerline))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
