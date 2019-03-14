;;; general Tweaks
(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode 0)
(server-start)
;; (set-frame-font "Source Code Pro" nil t)
(set-frame-font "Fira Code" nil t)
(set-face-attribute 'default t :font "Fira Code")

;;; Backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying
      t ; Don't delink hardlinks
      version-control
      t ; Use version numbers on backups
      delete-old-versions
      t ; Automatically delete excess backups
      kept-new-versions
      20 ; how many of the newest versions to keep
      kept-old-versions
      5 ; and how many of the old
      )

;;; Desktop
(desktop-save-mode 1)

;;; Custom Scripts
(load (expand-file-name "~/.roswell/helper.el"))
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer
	(buffer-list)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "065efdd71e6d1502877fd56
21b984cded01717930639ded0e569e1724d058af8" default))
 '(package-selected-packages
   '(polymode graphql-mode graphql inf-mongo web-mode counsel-projectile jade-mode srefactor sly-repl-ansi-color sly-quicklisp sly-macrostep sly ranger company-tabnine counsel-notmuch circe-notifications circe pretty-mode lispy info-beamer auctex-latexmk ag indium js-doc yasnippet-classic-snippets yasnippet-snippets ivy-yasnippet counsel sage-shell-mode dummyparens magit-filenotify docker-compose-mode docker xref-js2 js2-refactor flycheck-rtags flycheck ivy-rtags rtags auctex magit flycheck-rust avy-flycheck company racer cargo rust-mode restart-emacs json-mode multiple-cursors swiper ivy xresources-theme powerline))
 '(safe-local-variable-values '((TeX-master . t)))
 '(show-paren-mode t)
 '(tramp-syntax 'default nil (tramp)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
  (when mark-ring
    (let ((pos (marker-position (car (last mark-ring)))))
      (if (not (= (point) pos))
	  (goto-char pos)
	(setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
	(set-marker (mark-marker)
		    pos)
	(setq mark-ring (nbutlast mark-ring))
	(goto-char (marker-position (car (last mark-ring))))))))
(global-set-key (kbd "C-c m c")
		'mc/edit-lines)
(global-set-key (kbd "C-x <spc>")
		'mc/edit-lines)


;;; Packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))

(require 'srefactor)
(require 'srefactor-lisp)
;;;; Company
(with-eval-after-load 'company
  ;; (add-to-list 'company-backends #'company-tabnine)
  (global-company-mode)
  (setq company-show-numbers t)
  (setq company-idle-delay 0)
  (global-set-key (kbd "<C-tab>")
		  'company-complete)
  (define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
  (define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort)
  (company-tng-configure-default)
  (setq company-frontends '(company-tng-frontend company-pseudo-tooltip-frontend
						 company-echo-metadata-frontend)))

;;;; Magit
(global-set-key (kbd "C-x g")
		'magit-status)

;;;; Sage
(add-hook 'sage-shell-after-prompt-hook #'sage-shell-view-mode)

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
  (local-set-key (kbd "M-.")
		 'rtags-find-symbol-at-point)
  (local-set-key (kbd "M-,")
		 'rtags-find-references-at-point)
  (local-set-key (kbd "<C-left>")
		 'rtags-location-stack-back)
  (local-set-key (kbd "<C-right>")
		 'rtags-location-stack-forward)
  (local-set-key (kbd "<C-,>")
		 'rtags-print-symbol-info)
  (global-set-key (kbd "<f4>")
		  'ff-find-other-file)
  (rtags-enable-standard-keybindings)
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically
	      nil)
  (flycheck-mode))

(add-hook 'c-mode-hook 'c++-config)
(add-hook 'c++-mode-hook 'c++-config)

;;;; Ivy
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)

;;;; Rust
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c <tab>")
			   #'rust-format-buffer)))

;;;;; Racer
(setq racer-cmd "racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "~/src/rust/src") ;; Rust source code PATH

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;;;; Latex
(auctex-latexmk-setup)


;;;; JavasScipt
(require 'js2-refactor)
(require 'xref-js2)
(add-hook 'js2-mode-hook #'js2-refactor-mode)

(add-to-list 'auto-mode-alist
	     '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(js2r-add-keybindings-with-prefix "C-c C-r")
(add-hook 'js2-mode-hook #'indium-interaction-mode)
;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook
	  (lambda ()
	    (add-hook 'xref-backend-functions #'xref-js2-xref-backend
		      nil t)))

(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; (defun sm-greek-lambda ()
;;   (font-lock-add-keywords
;;    nil
;;    `(("\\<lambda\\>"
;;       (0
;;        (progn
;; 	 (compose-region
;; 	  (match-beginning 0)
;; 	  (match-end 0)
;; 	  ,(make-char
;; 	    'greek-iso8859-7
;; 	    107))
;; 	 nil))))))

;; (defmacro replace-seqs (chars modes)
;;   `(progn ,@(loop for char in chars collect `(replace-seq ,(first char) ,(second char) ,modes))
;; 	  nil))

;; (defmacro replace-seq (char replacement modes)
;;   (let ((fname (gensym)))
;;     `(progn
;;        (defun ,fname ()
;; 	 (font-lock-add-keywords
;; 	  nil
;; 	  '((,char (0
;; 		    (progn
;; 		      (compose-region (match-beginning 0)
;; 				      (match-end 0)
;; 				      ,replacement)
;; 		      nil))))))

;;        ,@(loop for mode in modes collect `(add-hook ,mode (quote ,fname)))
;;        nil)))

;; (replace-seqs (("#'" "⍘") ("\\<lambda\\>" "λ") ("\\<funcall\\>" "⨐")) ('emacs-lisp-mode-hook 'slime-repl-mode-hook))

(defun my-add-to-multiple-hooks (function hooks)
  (mapc (lambda (hook)
	  (add-hook hook function))
	hooks))

(my-add-to-multiple-hooks #'(lambda ()
			      (mapc (lambda (pair)
				      (push pair prettify-symbols-alist))
				    '( ;; Syntax
				      ("funcall" . #x2A10)
				      ("#'" . #x2358))))
			  '(emacs-lisp-mode-hook lisp-interaction-mode-hook lisp-mode-hook sly-mode-hook))


(add-hook 'emacs-lisp-mode-hook #'lispy-mode)
(add-hook 'eval-expression-minibuffer-setup-hook
	  #'lispy-mode)
(add-hook 'ielm-mode-hook #'lispy-mode)
(add-hook 'lisp-mode-hook #'lispy-mode)
(add-hook 'lisp-interaction-mode-hook #'lispy-mode)
(add-hook 'scheme-mode-hook #'lispy-mode)

(with-eval-after-load 'lispy
  (define-key lispy-mode-map (kbd "M-(") #'lispy-parens-auto-wrap)
  (setq lispy-use-sly t))

;;; Org
(require 'org-install)
(require 'org-habit)

(require 'doc-view)
(setq doc-view-resolution 144)


(setq org-treat-S-cursor-todo-selection-as-state-change
      nil)
(setq org-todo-state-tags-triggers (quote (("CANCELLED"
					    ("CANCELLED" . t))
					   ("WAITING"
					    ("WAITING" . t))
					   ("HOLD"
					    ("WAITING")
					    ("HOLD" . t))
					   (done ("WAITING")
						 ("HOLD"))
					   ("TODO"
					    ("WAITING")
					    ("CANCELLED")
					    ("HOLD"))
					   ("NEXT"
					    ("WAITING")
					    ("CANCELLED")
					    ("HOLD"))
					   ("DONE"
					    ("WAITING")
					    ("CANCELLED")
					    ("HOLD")))))


(setq org-todo-keywords '((sequence "TODO" "WAITING" "NEXT" "HOLD" "|"
				    "DONE")
			  (sequence "BESORGEN" "WARTEN" "|" "BESORGT")
			  (sequence "OUTOFSTOCK" "|" "INSTOCK")
			  (sequence "RESOLVE" "ASK" "RESEARCH" "|" "RESOLVED")
			  (sequence "HOMEWORK" "ACTIVE" "|" "FINISHED")))

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(setq org-directory "~/Documents/org")
(setq org-default-notes-file "~/Documents/org/refile.org")

;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c")
		'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates (quote (("t" "Todo"
				     entry
				     (file org-default-notes-file)
				     "* TODO %?\n%U\n%a\n")
				    ("n" "Note"
				     entry
				     (file org-default-notes-file)
				     "* %? :NOTE:\n%U\n%a\n")
				    ("q" "Question"
				     entry
				     (file "~/Documents/org/refile/questions.org")
				     "* RESOLVE %? :QUESTION:\n%U\n%a\n")
				    ("e" "Exercise"
				     entry
				     (file "~/Documents/org/refile/exercises.org")
				     "* HOMEWORK %? :EXERCISE:\n%a\n")
				    ("j" "Journal"
				     entry
				     (file+datetree "~/Documents/org/diary.org")
				     "**** %?\n%U\n")
				    ("m" "Meeting"
				     entry
				     (file org-default-notes-file)
				     "** %? :MEETING:\n"))))


(setq org-agenda-files (list "~/Documents/org/todo.org" "~/Documents/org/calendar.org"))

					;Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel .
				    9)
				 (org-agenda-files :maxlevel .
						   9))))

                                        ; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

                                        ; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

                                        ; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

                                        ; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;;;; Refile settings
                                        ; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2
		  (org-heading-components))
	     org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(global-set-key (kbd "C-c a")
		'org-agenda)
;; (org-super-agenda--def-auto-group path "their path in the outline"
;;   :key-form (org-super-agenda--when-with-marker-buffer (org-super-agenda--get-marker item)
;;               (when (org-up-heading-safe)
;; 		(org-format-outline-path (org-get-outline-path t t))
;;                 )))
;; (setq org-super-agenda-groups
;;       '(;; Each group has an implicit boolean OR operator between its selectors.
;; 	;; (:auto-parent t)

	
;; 	(:name "NEXT"		     ; Optionally specify section name
;; 	       ;; :auto-path t
;;                :todo "NEXT")
;; 	(:name "TODO"		     ; Optionally specify section name
;;                :todo "TODO")	   ; Items that have this TODO keyword
;; 	))

(setq org-agenda-custom-commands '(("X" agenda
				    ""
				    nil
				    ("~/Documents/org/out/agenda.html"))
				   ("n" "Notes"
				    tags
				    "NOTE"
				    ((org-agenda-overriding-header "Notes")
				     (org-tags-match-list-sublevels t))
				    ("~/Documents/org/out/notes.html"))
				   ("s" "Next"
				    todo
				    "NEXT"
				    ((org-agenda-overriding-header "Next")
				     (org-tags-match-list-sublevels t))
				    ("~/Documents/org/out/next.html"))
				   ("f" "Questions"
				    tags
				    "QUESTION"
				    ((org-agenda-overriding-header "Questions")
				     (org-tags-match-list-sublevels t))
				    ("~/Documents/org/out/question.html"))
				   ("l" "Einkaufsliste"
				    todo
				    "OUTOFSTOCK"
				    ((org-agenda-overriding-header "Einkaufsliste")
				     (org-tags-match-list-sublevels t))
				    ("~/Documents/org/out/einkaufsliste.html"))))

;;; Email
;;use org mode for eml files (useful for thunderbird plugin)
(add-to-list 'auto-mode-alist
	     '("\\.eml\\'" . org-mode))
(global-prettify-symbols-mode 1)

;;; Ricing
;; (require 'xresources-theme)
(load-theme 'solarized t)
(powerline-default-theme)
(global-set-key (kbd "M-g w")
		'avy-goto-word-1)
(put 'upcase-region 'disabled nil)
(global-pretty-mode t)
(pretty-activate-groups '(:sub-and-superscripts :greek :arithmetic-nary
						:arrows :arithmetic))

;;; Avy
(global-set-key (kbd "M-g w")
		'avy-goto-word-1)
(global-set-key (kbd "M-g f")
		'avy-goto-line)
(global-set-key (kbd "C-'")
		'avy-goto-char-2)

;;; IRC
(setq circe-network-options '(("Freenode" :tls t
			       :nick "hiro98"
			       :sasl-username "hiro98"
			       :sasl-password "valentin981"
			       :channels ("#emacs-circe"))))


(eval-after-load "circe-notifications"
  '(setq circe-notifications-watch-strings '("drmeister" "hiro" "hiro98")))

(add-hook 'circe-server-connected-hook 'enable-circe-notifications)


;;; Shortcuts
(move-text-default-bindings)

;;;; MC
(global-set-key (kbd "C-S-c C-S-c")
		'mc/edit-lines)
(global-set-key (kbd "C->")
		'mc/mark-next-like-this)
(global-set-key (kbd "C-<")
		'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")
		'mc/mark-all-like-this)
(define-key mc/keymap (kbd "<return>") nil)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)
(put 'narrow-to-region 'disabled nil)

;; JSDoc
(setq js-doc-mail-address "hiro@protagon.space"
      js-doc-author (format "Valentin Boettcher <%s>" js-doc-mail-address)
      js-doc-url "protagon.space"
      js-doc-license "MIT")

(add-hook 'js2-mode-hook
	  #'(lambda ()
	     (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
	     (define-key js2-mode-map "@" 'js-doc-insert-tag)))

;; Keybindings
(progn
  (define-key key-translation-map (kbd "H-3") (kbd "•")) ; bullet
  (define-key key-translation-map (kbd "H-4") (kbd "◇")) ; white diamond
  (define-key key-translation-map (kbd "H-5") (kbd "†")))


;; Projectile
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(counsel-projectile-mode)

;; Web Mode
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
      '(("ctemplate" . "/home/hiro/Documents/projects/seminarst/.*\\.html\\'")))

;; Rename Buffers
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defcustom pm-host/web
  (pm-host-chunkmode :name "web-mode"
                     :mode 'web-mode)
  "Markdown host chunkmode"
  :group 'poly-hostmodes
  :type 'object)

(defcustom  pm-inner/gql-fenced-code
  (pm-inner-chunkmode :name "gql-fenced-code"
			   :head-matcher "gql`.*$"
                           :tail-matcher "`.*$"
			   :head-mode 'host
			   :tail-mode 'host
                           :mode 'graphql-mode)
  "Markdown fenced code block."
  :group 'poly-innermodes
  :type 'object)

(defun gql () "graphql-mode")



(define-polymode poly-web-mode
  :hostmode 'pm-host/web
  :innermodes '(pm-inner/gql-fenced-code))
