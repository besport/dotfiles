(add-to-list 'load-path (concat user-emacs-directory "lisp"))

(require 'util)
(util-init-package-archives)
(setq package-selected-packages '(gnu-elpa-keyring-update ivy lsp-mode))
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

        whitespace-style (cl-set-difference
                          (cl-union whitespace-style '(lines-tail))
                          '(tabs
                            spaces
                            lines
                            newline
                            space-mark
                            tab-mark
                            newline-mark))
        ;; Do not display spaces, tabs and newlines marks.
        ))

(setq comint-prompt-read-only t
      comment-multi-line t
      compilation-scroll-output 'first-error
      compilation-context-lines 0
      disabled-command-function nil
      inhibit-startup-screen t
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

(add-hook 'before-save-hook 'delete-trailing-whitespace)

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

(when (fboundp 'lsp-deferred) (add-hook 'prog-mode-hook 'lsp-deferred))

(add-hook 'tuareg-mode-hook
          (lambda ()
            (setq ff-other-file-alist '(("\\.mli\\'" (".ml"))
                                        ("\\.ml\\'" (".mli"))
                                        ("\\.eliomi\\'" (".eliom"))
                                        ("\\.eliom\\'" (".eliomi"))))
            (setq-local comment-style 'indent)
            (setq-local tuareg-interactive-program
                        (concat tuareg-interactive-program " -nopromptcont"))
            (local-set-key (kbd "C-c C-a") 'ff-get-other-file)
            (add-hook 'before-save-hook 'ocamlformat-before-save t t)

            ;; HACK: Otherwise, LSP complains about internal errors on
            ;; some .eliom(i) files.
            (let ((ext (file-name-extension buffer-file-name)))
              (when (member ext '("eliom" "eliomi"))
                (setq-local lsp-modeline-code-actions-enable nil)))))

(column-number-mode 1)
(delete-selection-mode 1)
(electric-indent-mode 1)
(electric-pair-mode 1)
(global-auto-revert-mode 1)
(global-subword-mode 1)
(global-whitespace-mode 1)
(when (fboundp 'ivy-mode) (ivy-mode 1))

(menu-bar-mode 0)
;; Remove the top menu bar.

(savehist-mode 1)

(scroll-bar-mode 0)
;; Remove the vertical scroll bars.

(show-paren-mode 1)

(tool-bar-mode 0)
;; Remove the top tool bar.

(windmove-default-keybindings)
(winner-mode 1)

(server-start)
;; Allow this Emacs process to be a server for client processes started
;; using the command emacsclient.  To make use of this feature, you can
;; put the following lines in your `.bashrc':
;;
;;     emacsclient_frame="emacsclient --alternate-editor=emacs --create-frame"
;;     export EDITOR=$emacsclient_frame
;;     alias emacsc=$emacsclient_frame
;;
;; Run first and only once the command `emacs' to start the server and
;; then use `emacsc' to start a new Emacs client in its own graphical
;; window.  See
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Emacs-Server.html
;; for more details.
