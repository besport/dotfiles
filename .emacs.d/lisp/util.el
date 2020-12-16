(defun util-init-package-archives ()
  (require 'package)
  (add-to-list 'package-archives
               '("melpa-stable" . "https://stable.melpa.org/packages/") t)


  (add-to-list 'package-archive-priorities '("gnu" . 1))
  ;; Give a higher priority to the GNU ELPA repository.
  )

(provide 'util)
