(defun util-init-package-archives ()
  (require 'package)
  (add-to-list 'package-archives
               '("melpa-stable" . "https://stable.melpa.org/packages/") t)


  (mapc (lambda (priority) (add-to-list 'package-archive-priorities priority))
        '(("gnu" . 1) ("melpa-stable" . 0)))
  ;; Give a higher priority to the GNU ELPA repository.
  )

(provide 'util)
