(load-library "rng-auto")
(add-to-list 'auto-mode-alist
              (cons (concat "\\." (regexp-opt '("cshtml" "aspx" "xml" "xsd" "sch" "rng" "xslt" "svg" "rss" "bkl" "bkgen" "tpl" "jsp" "inc") t) "\\'")
                    'nxml-mode))
(setq magic-mode-alist (cons '("<\\?xml " . nxml-mode) magic-mode-alist))
(fset 'html-mode 'nxml-mode)
(fset 'xml-mode 'nxml-mode)
(add-hook 'nxml-mode-hook
          (lambda ()
            (set (make-local-variable 'ido-use-filename-at-point) nil)
            (require 'tagedit)
            (tagedit-add-paredit-like-keybindings)
            ))
(setq nxml-slash-auto-complete-flag t)

;; See: http://sinewalker.wordpress.com/2008/06/26/pretty-printing-xml-with-emacs-nxml-mode/
(defun pp-xml-region (begin end)
  "Pretty format XML markup in region. The function inserts
linebreaks to separate tags that have nothing but whitespace
between them.  It then indents the markup by using nxml's
indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end)))

;;----------------------------------------------------------------------------
;; Integration with tidy for html + xml
;;----------------------------------------------------------------------------
(add-hook 'nxml-mode-hook (lambda () (tidy-build-menu nxml-mode-map)))
(add-hook 'html-mode-hook (lambda () (tidy-build-menu html-mode-map)))

(add-auto-mode 'html-mode "\\.(jsp|tmpl)\\'")

(provide 'init-nxml)
