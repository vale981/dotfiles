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
(global-hl-line-mode 1)

(defun set-font ()
  (interactive)
  (set-frame-font "Fira Code" nil t))
;; (add-hook 'after-make-frame-functions #'set-font)

;;; Backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying
      t                                 ; Don't delink hardlinks
      version-control
      t                               ; Use version numbers on backups
      delete-old-versions
      t                          ; Automatically delete excess backups
      kept-new-versions
      20                     ; how many of the newest versions to keep
      kept-old-versions
      5                                 ; and how many of the old
      )

;;; Desktop
(desktop-save-mode 1)

;;; Custom Scripts
(load (expand-file-name "~/.roswell/helper.el"))
(defun close-all-buffers ()
  "Closes all buffers."
  (interactive)
  (mapc 'kill-buffer
	(buffer-list)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "065efdd71e6d1502877fd56
21b984cded01717930639ded0e569e1724d058af8" default)))
 '(package-selected-packages
   (quote
    (fish-mode pkgbuild-mode realgud fzf ein org-super-agenda company-lsp dap-mode lsp-ui lsp-mode elixir-yasnippets alchemist ethan-wspace sphinx-doc python-docstring elpy htmlize company-anaconda anaconda-mode graphql-mode graphql git-gutter-fringe+ git-timemachine flycheck-pos-tip modalka doom-modeline company-tern persp-projectile perspective all-the-icons-ivy all-the-icons-dired all-the-icons neotree rjsx-mode emmet-mode web-mode counsel-projectile jade-mode srefactor sly-repl-ansi-color sly-quicklisp sly-macrostep sly ranger company-tabnine counsel-notmuch circe-notifications circe pretty-mode lispy info-beamer auctex-latexmk ag indium js-doc yasnippet-classic-snippets yasnippet-snippets ivy-yasnippet counsel sage-shell-mode dummyparens magit-filenotify docker-compose-mode docker js2-refactor flycheck-rtags flycheck ivy-rtags rtags auctex magit flycheck-rust avy-flycheck company racer cargo rust-mode restart-emacs json-mode multiple-cursors swiper ivy xresources-theme powerline)))
 '(safe-local-variable-values (quote ((TeX-master . t))))
 '(show-paren-mode t)
 '(tramp-syntax (quote default) nil (tramp)))
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

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))

(require 'srefactor)
(require 'srefactor-lisp)
;;;; Company
(with-eval-after-load 'company
  ;; (add-to-list 'company-backends #'company-tabnine)
  (add-to-list 'company-backends 'company-tern)
  (add-to-list 'company-backends 'company-anaconda)
  (add-to-list 'company-backends 'company-lsp)

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
(with-eval-after-load 'recentf
  (setq ivy-use-virtual-buffers nil))
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "\C-x r") 'counsel-recentf)

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
(setq LaTeX-electric-left-right-brace t)


;;;; JavasScipt
(require 'js2-refactor)
(add-hook 'js2-mode-hook #'js2-refactor-mode)

(add-to-list 'auto-mode-alist
	     '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(js2r-add-keybindings-with-prefix "C-c C-r")
;; (add-hook 'js2-mode-hook #'indium-interaction-mode)
;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
;; (define-key js-mode-map (kbd "M-.") nil)

;; (add-hook 'js2-mode-hook
;; 	  (lambda ()
;; 	    (add-hook 'xref-backend-functions #'xref-js2-xref-backend
;; 		      nil t)))

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
				   '(;; Syntax
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
(setq org-src-fontify-natively t)

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
  "Exclude todo keywords with a done state from refile targets."
  (not (member (nth 2
		  (org-heading-components))
	     org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(global-set-key (kbd "C-c a")
		'org-agenda)
(setq org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")
         (timeline . "  % s")
         (todo .
               " %i %-12:c %(concat \"[ \"(org-format-outline-path (org-get-outline-path)) \" ]\") ")
         (tags .
               " %i %-12:c %(concat \"[ \"(org-format-outline-path (org-get-outline-path)) \" ]\") ")
         (search . " %i %-12:c"))
      )

;; (org-super-agenda--def-auto-group path "their path in the outline"
;;   :key-form (org-super-agenda--when-with-marker-buffer (org-super-agenda--get-marker item)
;;               (when (org-up-heading-safe)
;; 		(org-format-outline-path (org-get-outline-path t t))
;;                 )))
(setq org-super-agenda-groups
      '(;; Each group has an implicit boolean OR operator between its selectors.
	(:name "NEXT"
               :order 1
               :todo "NEXT")
        (:name "WAITING"
               :order 2
               :todo "WAITING")
	(:name "TODO"
               :order 3
               :todo "TODO")	   ; Items that have this TODO keyword
	))

(org-super-agenda-mode 1)

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
;; (doom-modeline-mode 1)
;; (global-set-key (kbd "M-g w")
;; 		'avy-goto-word-1)
;; (setq doom-modeline-height 5)
;; (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)
;; (setq doom-modeline-icon t)
;; (setq doom-modeline-major-mode-icon t)
;; (setq doom-modeline-major-mode-color-icon t)
;; (setq doom-modeline-persp-name t)
;; (setq doom-modeline-lsp t)
;; (setq doom-modeline-irc t)
;; (put 'upcase-region 'disabled nil)
(global-pretty-mode t)
(pretty-activate-groups '(:sub-and-superscripts :greek :arithmetic-nary
	                                        r					:arrows :arithmetic))
(defun my-prettify-symbols-compose-p (start end _match)
  "Return true iff the symbol MATCH should be composed.
The symbol starts at position START and ends at position END.
This is the default for `prettify-symbols-compose-predicate'
which is suitable for most programming languages such as C or Lisp."
  ;; Check that the chars should really be composed into a symbol.
  (let* ((syntaxes-beg (if (memq (char-syntax (char-after start)) '(?w ?_))
                           '(?w ?_) '(?. ?\\)))
         (syntaxes-end (if (memq (char-syntax (char-before end)) '(?w ?_))
                           '(?w ?_) '(?. ?\\))))
    (not (or (and
               (null (memq (char-before start) '(?_)))
               (memq (char-syntax (or (char-before start) ?\s)) syntaxes-beg))
             (and
               (null (memq (char-after end) '(?_)))
               (memq (char-syntax (or (char-after end) ?\s)) syntaxes-end))
             (nth 8 (syntax-ppss))))))
(setq prettify-symbols-compose-predicate #'my-prettify-symbols-compose-p)

;;; Avy
(global-set-key (kbd "M-g w")
		'avy-goto-word-1)
(global-set-key (kbd "M-g f")
		'avy-goto-line)
(global-set-key (kbd "C-'")
		'avy-goto-char-2)
(global-set-key (kbd "C-;") 'avy-goto-char-2)

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

;; Emmet
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'rjsx-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; Tree
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq projectile-switch-project-action 'neotree-projectile-action)

(global-set-key [f8] 'neotree-toggle)

;; Persp
(add-hook 'after-init-hook #'persp-mode)
(define-key projectile-mode-map (kbd "s-s") 'projectile-persp-switch-project)

;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

;; Tabs
(setq-default indent-tabs-mode nil)

;; Tern
(add-to-list 'load-path "~/src/tern")
(autoload 'tern-mode "tern.el" nil t)
(add-hook 'js2-mode-hook #'tern-mode)

;; Modalka
(defmacro mk-translate-kbd (from to)
  "Translate combinations of keys FROM to TO combination.
Effect of this translation is global."
  `(define-key key-translation-map (kbd ,from) (kbd ,to)))
;; (mk-translate-kbd "C-c C-p C-s C-s" "C-c p s s")

(modalka-define-kbd "SPC" "C-SPC")
;; '
(modalka-define-kbd "," "C-,")
;; -
(modalka-define-kbd "/" "M-.")
(modalka-define-kbd "." "C-.")
(modalka-define-kbd ":" "M-;")
(modalka-define-kbd ";" "C-;")
(modalka-define-kbd "?" "M-,")

(modalka-define-kbd "0" "C-0")
(modalka-define-kbd "1" "C-1")
(modalka-define-kbd "2" "C-2")
(modalka-define-kbd "3" "C-3")
(modalka-define-kbd "4" "C-4")
(modalka-define-kbd "5" "C-5")
(modalka-define-kbd "6" "C-6")
(modalka-define-kbd "7" "C-7")
(modalka-define-kbd "8" "C-8")
(modalka-define-kbd "9" "C-9")

(modalka-define-kbd "a" "C-a")
(modalka-define-kbd "b" "C-b")
;; (modalka-define-kbd "c b" "C-c C-b")
(modalka-define-kbd "c c" "C-c C-c")
;; (modalka-define-kbd "c k" "C-c C-k")
;; (modalka-define-kbd "c n" "C-c C-n")
;; (modalka-define-kbd "c s" "C-c C-s")
;; (modalka-define-kbd "c u" "C-c C-u")
;; (modalka-define-kbd "c v" "C-c C-v")
;; (modalka-define-kbd "c p p" "C-c p p")
(modalka-define-kbd "c p s" "C-c p s s")
(modalka-define-kbd "c p p" "C-c p p")
(modalka-define-kbd "c p f" "C-c p f")
(modalka-define-kbd "c p c" "C-c p O c")
(modalka-define-kbd "d" "C-d")
(modalka-define-kbd "e" "C-e")
(modalka-define-kbd "f" "C-f")
(modalka-define-kbd "g" "C-g")
(modalka-define-kbd "h" "M-h")
(modalka-define-kbd "i" "C-i")
(modalka-define-kbd "j" "M-j")
(modalka-define-kbd "k" "C-k")
(modalka-define-kbd "l" "C-l")
(modalka-define-kbd "m" "C-m")
(modalka-define-kbd "n" "C-n")
(modalka-define-kbd "o" "C-o")
(modalka-define-kbd "p" "C-p")
(modalka-define-kbd "q" "M-q")
(define-key modalka-mode-map (kbd "Q x") #'persp-switch)
(modalka-define-kbd "r" "C-r")
(modalka-define-kbd "s" "C-s")
(modalka-define-kbd "t" "C-t")
(modalka-define-kbd "u" "C-u")
(modalka-define-kbd "v" "C-v")
(modalka-define-kbd "w" "C-w")
(modalka-define-kbd "x ;" "C-x C-;")
(modalka-define-kbd "x e" "C-x C-e")
(modalka-define-kbd "x o" "C-x o")
(modalka-define-kbd "x f" "C-x C-f")
(modalka-define-kbd "x g" "C-x g")
(modalka-define-kbd "x b" "C-x b")
(modalka-define-kbd "x s" "C-x C-s")
(modalka-define-kbd "x S" "C-x s")
(modalka-define-kbd "x x s" "C-x x s")
(modalka-define-kbd "x 1" "C-x 1")
(modalka-define-kbd "x 2" "C-x 2")
(modalka-define-kbd "x 3" "C-x 3")
(modalka-define-kbd "x 4" "C-x 4")
(modalka-define-kbd "x <left>" "C-x <left>")
(modalka-define-kbd "x x <left>" "C-x x <left>")
(modalka-define-kbd "x <right>" "C-x <right>")
(modalka-define-kbd "x x <right>" "C-x x <right>")
(modalka-define-kbd "y" "C-y")
(modalka-define-kbd "z" "M-z")

(modalka-define-kbd "A" "M-SPC")
(modalka-define-kbd "B" "M-b")
(modalka-define-kbd "C" "M-c")
(modalka-define-kbd "D" "M-d")
(modalka-define-kbd "E" "M-e")
(modalka-define-kbd "F" "M-f")
(modalka-define-kbd "G" "C-`")
(modalka-define-kbd "H" "M-H")
;; J
(modalka-define-kbd "K" "M-k")
(modalka-define-kbd "L" "M-l")
(modalka-define-kbd "M" "M-m")
(modalka-define-kbd "N" "M-n")
(modalka-define-kbd "O" "M-o")
(modalka-define-kbd "P" "M-p")
(modalka-define-kbd "R" "M-r")
(modalka-define-kbd "S" "M-S")
(modalka-define-kbd "T" "M-t")
(modalka-define-kbd "U" "M-u")
(modalka-define-kbd "V" "M-v")
(modalka-define-kbd "W" "M-w")
;; X
(modalka-define-kbd "Y" "M-y")
(modalka-define-kbd "Z" "C-z")
(modalka-define-kbd "<" "M-<")
(modalka-define-kbd ">" "M->")
(global-set-key (kbd "<escape>") #'modalka-mode)

(setq-default cursor-type 'box)
(setq modalka-cursor-type '(bar . 1))

;; Gutter
(require 'git-gutter-fringe+)
(global-git-gutter+-mode 1)
(git-gutter-fr+-minimal)
(git-gutter+-turn-on)

;; KBD Macros
(fset 'create-intl
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([23 backspace 60 70 111 114 109 97 116 116 101 100 77 101 115 115 97 103 101 32 105 100 61 21 134217786 105 100 return 32 24 111 5 return 21 134217786 105 100 return 58 32 39 25 6 44 24 111] 0 "%d") arg)))

;; Python
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook (lambda ()
                              (require 'sphinx-doc)
                              (sphinx-doc-mode t)
                              (whitespace-mode 1)
                              (python-docstring-mode 1)))
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(require 'dap-python)
(setq whitespace-line-collumn 79)
(setq whitespace-style '(face empty tabs lines-tail trailing))



;; YAS
(yas-global-mode 1)

;; Whitespace and teaks
(global-ethan-wspace-mode 1)
(setq mode-require-final-newline nil)
(electric-pair-mode 1)

;; EIN
(setq ein:output-type-preference
      '(emacs-lisp svg png jpeg html text latex javascript))

;; Elixir
(add-hook 'elixir-mode-hook #'lsp)
(setq lsp-clients-elixir-server-executable "/home/hiro/src/elixir-ls/rel/language_server.sh")

(setq lsp-prefer-flymake nil)
(setq lsp-ui-doc-enable t
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-position 'top
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable nil
        lsp-ui-flycheck-enable t
        lsp-ui-flycheck-list-position 'right
        lsp-ui-flycheck-live-reporting t
        lsp-ui-peek-enable t
        lsp-ui-peek-list-width 60
        lsp-ui-peek-peek-height 25)

(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-to-list 'exec-path "/home/hiro/src/elixir-ls/rel/language_server.sh")
