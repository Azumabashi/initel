;; initialize leaf
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; config starts here
(provide 'init)

;; use settings from shell
(exec-path-from-shell-initialize)

; show line numbers
(global-display-line-numbers-mode)

; hide tool bar and menu bar
(tool-bar-mode 0)

; enhance corresponding parentheses
(show-paren-mode 1)

(leaf doom-themes
  :ensure t
  :custom ((doom-themes-enable-bold . t)
	   (doom-themes-enable-italic . t)
	   (doom-themes-treemacs-theme . "doom-atom"))
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

;; add corresponding parentheses
(leaf smartparens
  :ensure t
  :config
  (smartparens-global-mode t))

;; show indent guide
(leaf indent-guide
  :ensure t
  :custom ((indent-guide-char . " "))
  :config
  (indent-guide-global-mode)
  (set-face-background 'indent-guide-face "dimgray"))

;; skk
(leaf skk
  :ensure ddskk
  :bind ("C-x C-j" . skk-mode)
  :custom (
	   (default-input-method . "japanese-skk")
	   (skk-kutouten-type . 'en)
	   (skk-rom-kana-rule-list . '(
		("(" nil "（")
		(")" nil "）")
		("!" nil "！")))))


;; migemo
(leaf migemo
  :ensure t
  :custom ((migemo-command . "cmigemo")
	   (migemo-options . '("-q" "--emacs"))
	   (migemo-dictionary . "/usr/local/share/migemo/utf-8/migemo-dict"))
  :config
  (load-library "migemo")
  (migemo-init)
  )

;; yatex
(leaf yatex
  :ensure t
  :mode "\\.tex"
  :custom ((tex-command . "lualatex")
	   (bibtex-command . "biber --bblencoding=utf8 -u -U --output_safechars'")
	   (tex-pdfview-command . "open -a Skim")))

;; python
(leaf python-mode
  :ensure t
  :mode "\\.py")

;; nim
(leaf nim-mode
  :ensure t
  :mode ("\\.nim" "\\.nims"))

;; ivy
(leaf ivy
  :ensure t
  :custom ((ivy-use-virtual-buffers . t)
	   (enable-recursive-minibuffers . t)
	   (ivy-height . 30)
	   (ivy-extra-directories . nil)
	   (ivy-re-builders-alist . '((t . ivy--regex-plus)))))

;; counsel
(leaf counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file))
  :custom ((counsel-find-file-ignore-regexp . (regexp-opt '("./" "../")))
	   (counsel-find-file-ignore-regexp . (regexp-opt '(".DS_Store")))))

;; multiple cursors
(leaf multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
	 ("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-previous-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)))

;; company
(leaf company
  :ensure t
  :config
  (global-company-mode))

;; delete by C-h
(keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "C-?") 'help-for-help)

;; set count-words-regions to M-c
(global-set-key (kbd "M-c") 'count-words-region)

;; utility functions
(defun region-replace (str newstr begin end)
  "指定範囲内で置換を行う"
  (goto-char begin)
  (while (search-forward str end t)
    (replace-match newstr)))

(defun pirikan ()
  "選択範囲内の句読点をコンマとピリオドに置き換える"
  (interactive)
  (let ((curpos (point))
        (begin (if (region-active-p)
                   (region-beginning) (point-min)))
        (end (if (region-active-p)
                 (region-end) nil)))
    (region-replace "。" "．" begin end)
    (region-replace "、" "，" begin end)
    (goto-char curpos)))

(defun depirikan ()
  "pirikan の逆をする"
  (interactive)
  (let ((curpos (point))
        (begin (if (region-active-p)
                   (region-beginning) (point-min)))
        (end (if (region-active-p)
                 (region-end) nil)))
    (region-replace "．" "。" begin end)
    (region-replace "，" "、" begin end)
    (goto-char curpos)))

(defun maru ()
  "．を。に変換する"
  (interactive)
  (let ((curpos (point))
        (begin (if (region-active-p)
                   (region-beginning) (point-min)))
        (end (if (region-active-p)
                 (region-end) nil)))
    (region-replace "．" "。" begin end)
    (goto-char curpos)))

;; font specification:
;; Use Options -> Set Default Font
;; The configuration will be on ~/.emacs.d/custom-set-variables.el.

;; enable turning back the lines in org-mode
(setq org-startup-truncated nil)

; create custom-set-variables to another file
(setq custom-file "~/.emacs.d/custom-set-variables.el")
(load custom-file)
