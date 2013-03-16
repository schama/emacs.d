(require 'go-mode-load)
(require 'go-autocomplete)

;; 让 speedbar 识别go文件
(speedbar-add-supported-extension ".go")

;; go-mode-hook
(add-hook 'go-mode-hook '(lambda ()
		;; gocode
		(auto-complete-mode 1)
		(setq ac-sources '(ac-source-go))
	
		;; Imenu & Speedbar
		(setq imenu-generic-expression
			'(("type" "^type *\\([^ \t\n\r\f]*\\)" 1)
			("func" "^func *\\(.*\\) {" 1)))
		(imenu-add-to-menubar "Index")
	
		;; Outline mode
		(make-local-variable 'outline-regexp)
		(setq outline-regexp "//\\.\\|//[^\r\n\f][^\r\n\f]\\|pack\\|func\\|impo\\|cons\\|var.\\|type\\|\t\t*….")
		(outline-minor-mode 1)
		(local-set-key "\M-a" 'outline-previous-visible-heading)
		(local-set-key "\M-e" 'outline-next-visible-heading)
		(local-unset-key (kbd "C-x C-s"))
		(local-set-key (kbd "C-x C-s")
						(lambda ()
							(interactive)
							(gofmt)
							(save-buffer)))
		(local-set-key (kbd "M-g r") 'go-run)
		(local-set-key (kbd "M-g f") 'gofmt)
		(local-set-key (kbd "M-g c") 'go-fix-buffer)
		(local-set-key (kbd "M-g s") 'go-setenv)
	
		;; Menu bar
		(require 'easymenu)
		(defconst go-hooked-menu
		'("Go tools"
		["Go run buffer" go-run t]
		["Go reformat buffer" gofmt t]
		["Go check buffer" go-fix-buffer t]
		["Go set temp gopath" go-setenv t]))
		(easy-menu-define
			go-added-menu
			(current-local-map)
			"Go tools"
			go-hooked-menu)

		;; Other
		(setq show-trailing-whitespace t)
))

;; helper function
(defun go-run ()
	"run current buffer"
	(interactive)
	(compile (concat "go run " (buffer-file-name))))

;; helper function
(defun go-setenv ()
    "set temp environment varialbe for GOPATH"
    (interactive)
    (setq new-path (concat 
						(read-directory-name "GoPath:" (buffer-file-name)) 
						":"
						(getenv "GOPATH")))
    (setenv "GOPATH" new-path))


;; helper function
(defun go-fix-buffer ()
	"run gofix on current buffer"
	(interactive)
	(show-all)
	(shell-command-on-region (point-min) (point-max) "go tool fix -diff"))
	
(provide 'init-golang)
