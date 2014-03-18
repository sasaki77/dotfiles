;; Emacs 23より前のバージョンを利用している場合
;; user-emacs-directory変数が未定義のため次の設定を追加
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

;; バックアップファイルの作成場所をシステムのTempディレクトリに変更する
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
;; オートセーブファイルの作成場所をシステムのTempディレクトリに変更する
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;; --------------------------------------------------
;; PATH
;; --------------------------------------------------

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")


;; --------------------------------------------------
;; encoding
;; --------------------------------------------------

;; 言語を日本語にする
(set-language-environment "Japanese")

(require 'ucs-normalize)
(set-file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)
(set-default-coding-systems 'utf-8-hfs)
(set-buffer-file-coding-system 'utf-8-hfs)
(set-terminal-coding-system 'utf-8-hfs)
(set-keyboard-coding-system 'utf-8-hfs)

;; 極力UTF-8-HFSとする
(prefer-coding-system 'utf-8-hfs)

;; --------------------------------------------------
;; window setting
;; --------------------------------------------------

;; windowのサイズを設定
(setq initial-frame-alist
      (append (list
	       '(width . 90)
	       '(height . 49)
	       '(top . o)
	       '(left . 0)
	       )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)

;; フレームのalphaを設定
(set-frame-parameter (selected-frame) 'alpha 0.85)

;; ターミナル以外はツールバーを非表示
(when window-system
  ;; tool-barを非表示
  (tool-bar-mode 0))

;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format
      (format "%%&%%f -Emacs@%s" (system-name)))

;; カラム番号も表示
(column-number-mode t)

;; ビープ音の消去
(setq ring-bell-function 'ignore)

;; --------------------------------------------------
;; color
;; --------------------------------------------------

;; Color
(if window-system (progn
  ;; 背景色
  (add-to-list 'default-frame-alist '(background-color . "black"))
  ;; 文字色
  (add-to-list 'default-frame-alist '(foreground-color . "azure3"))
  ;; カーソル色
  (add-to-list 'default-frame-alist '(cursor-color . "white"))
  ;; マウス色
  (add-to-list 'default-frame-alist '(mouse-color . "white"))
  (add-to-list 'default-frame-alist '(border-color . "black"))
))

;; 選択領域の色
(set-face-background 'region "#555")

;; 対応する括弧を光らせる
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "Brown")

;; --------------------------------------------------
;; font
;; --------------------------------------------------

;; フォントの設定
(set-face-attribute 'default nil
                    :family "Monaco" ;;英語
		    ;:family "Ricty"
                    :height 120)

(set-fontset-font
 nil 'japanese-jisx0208
 (font-spec :family "Hiragino Maru Gothic Pro"))


;; フレームの大きさを設定する関数
(defun set-selected-frame-size (width height)
  (interactive "nWidth(90):  \nnHeight(49): ")
  (set-frame-size (selected-frame) width height)
  )

;; --------------------------------------------------
;; original function
;; --------------------------------------------------

;; フレームの縦方向の大きさを変更する関数
(defun set-selected-frame-height (height)
  (interactive "nHeight(49): ")
  (set-frame-height (selected-frame) height )
  )

;; フレームの横方向の大きさを変更する関数
(defun set-selected-frame-width (width)
  (interactive "nWidth(90): ")
  (set-frame-width (selected-frame) width )
  )

;; フレームの透明度を変更する関数
(defun set-selected-frame-alpha (alpha_value)
  (interactive "nalpha: ")
  (set-frame-parameter (selected-frame) 'alpha alpha_value)
  )

;; フレーム関連のキーバインド
(define-key global-map (kbd "C-c f s") 'set-selected-frame-size)
(define-key global-map (kbd "C-c f h") 'set-selected-frame-height)
(define-key global-map (kbd "C-c f w") 'set-selected-frame-width)
(define-key global-map (kbd "C-c f a") 'set-selected-frame-alpha)

;; --------------------------------------------------
;; emacs-lisp-mode-hook
;; --------------------------------------------------

(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

;; emacs-lisp-modeのフックをセット
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;; --------------------------------------------------
;; migemo
;; --------------------------------------------------

(require 'migemo)
(setq migemo-command "/usr/local/bin/cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(migemo-init)
(set-process-query-on-exit-flag (get-process "migemo") nil)

;; --------------------------------------------------
;; auto-install
;; --------------------------------------------------

(when (require 'auto-install nil t)
  ;; インストールディスクを設定する。初期値は~/.emacs.d/auto-install/
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelispの名前を取得する
  ;; autp-install利用時には以下のコメントアウトを外す
  ;;(auto-install-update-emacswiki-package-name t)
  ;;(auto-install-compatibility-setup)
  )

;; --------------------------------------------------
;; redo+
;; --------------------------------------------------

;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
(when (require 'redo+ nil t)
  ;; C--にリドゥを割り当てる
  (define-key global-map (kbd "C--") 'redo))

;; --------------------------------------------------
;; ELPA
;; --------------------------------------------------

(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発運営者のELPAを追加
  (add-to-list 'package-archives
   	       '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize)
  )

;; --------------------------------------------------
;; wdired
;; --------------------------------------------------

;; (auto-install-from-emacswiki "wdired")
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; --------------------------------------------------
;; point-do
;; --------------------------------------------------

;; (auto-install-from-emacswiki "point-undo.el")
(when (require 'point-undo nil t)
  (define-key global-map (kbd "M-[") 'point-undo)
  (define-key global-map (kbd "M-]") 'point-redo))

;; --------------------------------------------------
;; autp-complete
;; --------------------------------------------------

(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
	       "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default)
  (setq ac-use-menu-map t) ;; C-n/C-pで候補選択可能
  (add-to-list 'ac-sources 'ac-source-yasnippet) ;; 常にYASnippetを補完候補に
  (setq ac-delay 0.5)
  (setq ac-auto-start 5)
  (setq ac-auto-show-menu 0.5)
  (setq ac-candidate-limit 50))
(global-auto-complete-mode t)

;; --------------------------------------------------
;; ajc-java-complete
;; --------------------------------------------------

(require 'ajc-java-complete-config)
(add-hook 'java-mode-hook 'ajc-java-complete-mode)
(add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)

;; --------------------------------------------------
;; Anything
;; --------------------------------------------------

;; (auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描画するまでの時間。デフォルトは50
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多い時に体感速度を速くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限ではアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
	     (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; Lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))

;; anything-for-document用のソースを定義
(setq anything-for-document-sources
      (list anything-c-source-man-pages
	    anything-c-source-info-cl
	    anything-c-source-info-pages
	    anything-c-source-info-elisp
	    anything-c-source-apropos-emacs-commands
	    anything-c-source-apropos-emacs-functions
	    anything-c-source-apropos-emacs-variables))

;; anything-for-documentコマンドを作成
(defun anything-for-document ()
  "Preconfigured `anything' for anything-for-document."
  (interactive)
  (anything anything-for-document-sources 
	    (thing-at-point 'symbol) nil nil nil 
	    "*anything for document*"))

;; "C-c C-d"にanything-for-documentを割り当て
(define-key global-map (kbd "C-c C-d") 'anything-for-document)

;; --------------------------------------------------
;; yasnippet
;; --------------------------------------------------

(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets" ;; 作成するスニペットはここに入る
	))
(yas-global-mode 1)
(defvar yas-candidates nil)

(defun init-yas-candidates ()
  (let ((table (yas/get-snippet-tables major-mode)))
    (if table
	(let (candidates (list))
	  (mapcar (lambda (mode)          
		    (maphash (lambda (key value)    
			       (push key candidates))          
			     (yas/table-hash mode))) 
		  table)				
	  (setq yas-candidates candidates)))))


(defvar ac-new-yas-source
  '(	(init		.	init-yas-candidates)
	(candidates	.	yas-candidates)
	(action		.	yas/expand)
	(symbol		.	"a")))

(provide 'my-yas-funs)
;; 単語展開キーバインド (ver8.0から明記しないと機能しない)
(custom-set-variables '(yas-trigger-key "<backtab>"))
;; 次の候補への移動
(custom-set-variables '(yas-next-field-key "TAB"))
;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-c i i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-c i b") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
(define-key yas-minor-mode-map (kbd "C-c i v") 'yas-visit-snippet-file)
;; スニペットのテーブルを閲覧する
(define-key yas-minor-mode-map (kbd "C-c i d") 'yas-describe-tables)
;; anything interface
(eval-after-load "anything-config"
  '(progn
     (defun my-yas/prompt (prompt choices &optional display-fn)
       (let* ((names (loop for choice in choices
                           collect (or (and display-fn (funcall display-fn choice))
                                       choice)))
              (selected (anything-other-buffer
                         `(((name	.	,(format "%s" prompt))
                            (candidates .	names)
                            (action	.	(("Insert snippet" . (lambda (arg) arg))))))
                         "*anything yas/prompt*")))
         (if selected
             (let ((n (position selected names :test 'equal)))
               (nth n choices))
           (signal 'quit "user quit!"))))
     (custom-set-variables '(yas/prompt-functions '(my-yas/prompt)))
     (define-key anything-command-map (kbd "y") 'yas/insert-snippet)))
;;; yasnippetのbindingを指定するとエラーが出るので回避する方法。
(setf (symbol-function 'yas-active-keys)
      (lambda ()
        (remove-duplicates (mapcan #'yas--table-all-keys (yas--get-snippet-tables)))))

;; --------------------------------------------------
;; popwin
;; --------------------------------------------------

;;;(auto-install-from-url "https://github.com/m2ym/popwin-el/raw/master/popwin.el")
(require 'popwin)
(setq popwin:popup-window-height 23)
(setq display-buffer-function 'popwin:display-buffer)
(require 'dired-x)
(push '(dired-mode :position top) popwin:special-display-config)
;;;(require 'popwin-yatex)
;;;(push '("*YaTeX-typesetting*") popwin:special-display-config)

;; --------------------------------------------------
;; flymake
;; --------------------------------------------------

(require 'flymake)

;; Makefileの種類を定義
(defvar flymake-makefile-filenames
  '("Makefile" "makefile" "GNUmakefile")
  "File names for make.")

;; makefileがなければコマンドを直接利用するコマンドラインを生成
(defun flymake-get-make-gcc-cmdline (source base-dir)
  (let (found)
    (dolist (makefile flymake-makefile-filenames)
      (if (file-readable-p (concat base-dir "/" makefile))
	  (setq found t)))
    (if found
	(list "make"
	      (list "-s"
		    "-C"
		    base-dir
		    (concat "CHK_SOURCE=" source)
		    "SYNTAX_CHECK-MODE=1"
		    "check-syntax"))
      (list (if (string= (file-name-extension source) "c") "gcc" "g++")
	    (list "-o"
		  "/dev/null"
		  "-fsyntax-only"
		  "-Wall"
		  source)))))

;; Flymake初期化関数の生成
(defun flymake-simple-make-gcc-init-impl
  (create-temp-f use-relative-base-dir
		 use-relative-source build-file-name get-cmdline-f)
  "Create syntax check command line for a directly checked source file. Use CREATE-TEMP-F for creating temp copy. "
  (let* ((args nil)
	 (source-file-name buffer-file-name)
	 (buildfile-dir (file-name-directory source-file-name)))
    (if buildfile-dir
	(let* ((temp-source-file-name
		(flymake-init-create-temp-buffer-copy create-temp-f)))
	  (setq args
		(flymake-get-syntax-check-program-args
		 temp-source-file-name
		 buildfile-dir
		 use-relative-base-dir
		 use-relative-source
		 get-cmdline-f))))
    args))

;; 初期化関数を定義
(defun flymake-simple-make-gcc-init ()
  (message "%s" (flymake-simple-make-gcc-init-impl
		 'flymake-create-temp-inplace t t "Makefile"
		 'flymake-get-make-gcc-cmdline))
  (flymake-simple-make-gcc-init-impl
   'flymake-create-temp-inplace t t "Makefile"
   'flymake-get-make-gcc-cmdline))

;; 拡張子 .c .cpp, c++などの時に上記の関数を利用する
(add-to-list 'flymake-allowed-file-name-masks
 	     '("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'"
 	       flymake-simple-make-gcc-init))

;; --------------------------------------------------
;; color-moccur
;; --------------------------------------------------

;; (auto-install-from-emacswiki "color-moccur.el")
(when (require 'color-moccur nil t)
  ;; M-o に occur-by-moccur を割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索の時除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
	     (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;; --------------------------------------------------
;; moccur-edit
;; --------------------------------------------------

;; (auto-install-from-emacswiki "moccur-edit.el")
(require 'moccur-edit nil t)

;; --------------------------------------------------
;; undohist
;; --------------------------------------------------

;; (install-elisp "http://cx4a.org/pub/undohist.el")
(when (require 'undohist nil t)
  (undohist-initialize))

;; --------------------------------------------------
;; undo-tree
;; --------------------------------------------------
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;; --------------------------------------------------
;; multi-term
;; --------------------------------------------------

;; (package-install "multi-term")
(when (require 'multi-term nil t)
  ;; 使用するシェルの指定
  (setq multi-term-program "/bin/bash"))

;; --------------------------------------------------
;; Egg
;; --------------------------------------------------

;; (install-elisp "https://raw.github.com/byplayer/egg/master/egg.el")
(when (executable-find "git")
  (require 'egg nil t))

;; --------------------------------------------------
;; gtags-mode
;; --------------------------------------------------
;; (setq gtags-suggested-key-mapping t)
(require 'gtags nil t)

;; --------------------------------------------------
;; ctags
;; --------------------------------------------------
;; (package-install "ctags")
					;(require 'ctags nil t)
;;(setq tags-revert-without-query t)
;; ctagsを呼び出すコマンドライン。パスが通っていればフルパスでなくても良い
;; etags互換タグを利用する場合はコメントを外す
;; (setq ctags-command "ctags -e -R"
;; (setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
;;(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; --------------------------------------------------
;; howm
;; --------------------------------------------------

;; howmメモ保存の場所
(setq howm-directory (concat user-emacs-directory "howm"))
;; howm-menuの言語を日本語に
(setq howm-memu-lang 'ja)
;; howmメモを1日1ファイルにする
;;;(setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")
;; howm-modeを読み込む
(when (require 'howm nil t)
  ;; C-c,,でhowm-menuを起動
  (define-key global-map (kbd "C-c ,,") 'howm-menu))
;; howmメモを保存と同時に閉じる
(defun howm-save-buffer-and-kill ()
  "howmメモを保存と同時に閉じます。"
  (interactive)
  (when (and (buffer-file-name)
	     (string-match "\\.howm" (buffer-file-name)))
    (save-buffer)
    (kill-buffer nil)))
;; C-c C-cでメモの保存と同時にバッファを閉じる
(define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)

;; --------------------------------------------------
;; cua-mode
;; --------------------------------------------------
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; --------------------------------------------------
;; org-mode
;; --------------------------------------------------

(setq org-todo-keywords
      '((sequence "TODO(t)""WAIT(w)"|"DONE(d)""SOMEDAY(s)")))
;; DONEの時刻を記録
(setq org-log-done 'time)

;; --------------------------------------------------
;; YaTex
;; --------------------------------------------------

(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;;;(setq load-path(cons(expand-file-name "~/.emacs.d/site-lisp/yatex")load-path))

;; Settings for platex command
;; texファイルの文字コードによってここを変える必要がある
(setq tex-command "platex --kanji=sjis")
;;;(setq tex-command "platex --kanji=euc --fmt=platex-euc")


;; Settings for Previwer Mxdvi
(setq dvi2-command "open -a PictPrinter")

;; prefixを変える
(setq YaTeX-prefix "\C-c")

;; AMS-Latexを使用する
(setq YaTex-use-AMS-LaTex t)

;; YaTeXでコメントアウト、解除を割り当てる
(add-hook 'yatex-mode-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-c" 'comment-region)
	     (local-set-key "\C-c\C-u" 'uncomment-region)
	     (local-set-key "\C-c\C-a" 'auto-complete-mode)
	     ))

;; auto-complete-latexの設定
(require 'auto-complete-latex)
(setq ac-l-dict-directory "~/.emacs.d/elisp/auto-complete-latex/ac-l-dict")

;; 文章作成時の漢字コードの設定
;; 1 = Shift_JIS, 2 = ISO-2022-JP, 3 = EUC-JP
;; default は 2
(setq YaTeX-kanji-code 1)

;; (autoload 'latex-indent-command "~/misc/latex-indent"
;;   "Indent current line accroding to LaTeX block structure.")
;; (autoload 'latex-indent-region-command "~/misc/latex-indent"
;;   "Indent each line in the region according to LaTeX block structure.")
;; (add-hook
;;  'latex-mode-hook
;;  '(lambda ()
;;     (define-key tex-mode-map "\t"	 'latex-indent-command)
;;     (define-key tex-mode-map "\M-\C-\\" 'latex-indent-region-command)))

;; --------------------------------------------------
;; global keybind
;; --------------------------------------------------

;; "C-t"でウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t")	'next-multiframe-window)
(define-key global-map (kbd "C-S-t")	'previous-multiframe-window)
(define-key global-map (kbd "C-m")	'newline-and-indent)
(define-key global-map (kbd "C-x C-b")	'anything-for-files)
(define-key global-map (kbd "C-c C-y")	'anything-show-kill-ring)
(define-key global-map (kbd "C-z")	'cua-scroll-down)
(define-key global-map (kbd "C-c a")	'align)
(define-key global-map (kbd "C-S-i")	'indent-region)
(define-key global-map (kbd "C-,")	'replace-string)
