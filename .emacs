(add-to-list 'load-path (concat user-emacs-directory "lisp"))

(require 'util)
(util-init-package-archives)
(setq package-selected-packages '(gnu-elpa-keyring-update ivy))
(package-initialize)
(package-install-selected-packages)

(defconst opam-lisp-dir
  (let ((opam-share
         (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
    (when (and opam-share (file-directory-p opam-share))
      (expand-file-name "emacs/site-lisp/" opam-share))))
;; Directory name (depends on the active OPAM switch when Emacs was
;; started) where OPAM stores Emacs Lisp files.

(add-to-list 'load-path opam-lisp-dir)
(load (concat opam-lisp-dir "tuareg-site-file"))
(require 'merlin)
(require 'dune)
(require 'ocamlformat)

(setq-default fill-column 72
              indent-tabs-mode nil
              mode-line-format (remove '(vc-mode vc-mode) mode-line-format)
              require-final-newline t
              scroll-down-aggressively 0
              scroll-up-aggressively 0)

(with-eval-after-load "whitespace"
  (setq whitespace-global-modes '(not dired-mode archive-mode)
        ;; Turn off whitespace-mode in Dired-like buffers.

        whitespace-style (cl-set-difference whitespace-style '(tabs
                                                               spaces
                                                               newline
                                                               space-mark
                                                               tab-mark
                                                               newline-mark))
        ;; Do not display spaces, tabs and newlines marks.

        whitespace-action '(auto-cleanup)))

(setq comint-prompt-read-only t
      comment-multi-line t
      compilation-scroll-output 'first-error
      compilation-context-lines 0
      disabled-command-function nil
      inhibit-startup-screen t
      merlin-command 'opam
      merlin-completion-with-doc t
      sql-product 'postgres
      track-eol t
      tuareg-interactive-read-only-input t
      view-read-only t
      vc-follow-symlinks t)

(mapc (lambda (ext) (add-to-list 'completion-ignored-extensions ext))
      '(".bc" ".byte" ".exe" ".native"))

(mapc (lambda (ext) (add-to-list 'auto-mode-alist ext))
      '(("dune-project\\'" . dune-mode)
        ("dune-workspace\\'" . dune-mode)
        ("README\\'" . text-mode)
        ("\\.dockerignore\\'" . conf-unix-mode)
        ("\\.gitignore\\'" . conf-unix-mode)
        ("\\.merlin\\'" . conf-space-mode)
        ("\\.ocamlinit\\'" . tuareg-mode)
        ("\\.top\\'" . tuareg-mode)))

(add-to-list 'auto-mode-alist '("\\.[^\\.].*\\'" nil t) t)
;; Hack to open files like Makefile.local with the right mode.

(add-hook 'text-mode-hook 'auto-fill-mode)

(add-hook 'find-file-hook
          (lambda ()
            (require 'smerge-mode)
            (save-excursion
              (goto-char (point-min))
              (when (re-search-forward smerge-begin-re nil t)
                (smerge-mode 1))))
          t)
;; Enable smerge-mode when there is a conflict in the visited file.
;; Source:
;; https://github.com/emacs-mirror/emacs/blob/2e7402b760576b54a326fca593c948a73bc3d6d0/lisp/vc/smerge-mode.el#L33-L38

(add-hook 'tuareg-mode-hook
          (lambda ()
            (setq ff-other-file-alist '(("\\.mli\\'" (".ml"))
                                        ("\\.ml\\'" (".mli"))
                                        ("\\.eliomi\\'" (".eliom"))
                                        ("\\.eliom\\'" (".eliomi"))))
            (setq-local comment-style 'indent)
            (setq-local tuareg-interactive-program
                        (concat tuareg-interactive-program " -nopromptcont"))
            (let ((ext (file-name-extension buffer-file-name)))
              (when (string-equal ext "eliom")
                (setq-local ocamlformat-file-kind 'implementation))
              (when (string-equal ext "eliomi")
                (setq-local ocamlformat-file-kind 'interface)))
            (local-set-key (kbd "C-c C-a") 'ff-get-other-file)
            (add-hook 'before-save-hook 'ocamlformat-before-save t t)
            (merlin-mode)))

(column-number-mode 1)
(delete-selection-mode 1)
(electric-indent-mode 1)
(electric-pair-mode 1)
(global-auto-revert-mode 1)
(global-subword-mode 1)
(global-whitespace-mode 1)
(when (fboundp 'ivy-mode) (ivy-mode 1))
(menu-bar-mode 0)
(savehist-mode 1)
(scroll-bar-mode 0)
(show-paren-mode 1)
(tool-bar-mode 0)
(windmove-default-keybindings)
(winner-mode 1)

(server-start)
;; Allow this Emacs process to be a server for client processes started
;; using the command emacsclient.
