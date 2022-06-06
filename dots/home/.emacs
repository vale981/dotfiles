(defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
        (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(use-package org)
;; (straight-use-package 'org '(org :host github :repo "yantar92/org" :branch "feature/org-fold-universal-core"
;;                                  :files (:defaults "contrib/lisp/*.el")))
(org-babel-load-file "~/.emacs.d/emacs.org")
(put 'scroll-left 'disabled nil)
