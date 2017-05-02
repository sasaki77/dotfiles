" ======================================== 
" Auto Command
" ======================================== 
" release autogroup in MyAutoCmd
augroup MyAutoCmd
	autocmd!
augroup END

" ======================================== 
" System Settings
" ======================================== 
" マウスの設定
if has('mouse')
	set mouse=a
endif

" コマンドライン補完の強化
set wildmenu

" ======================================== 
" Indent Settings
" ======================================== 
set autoindent	  "新しい行のインデントを現在行と同じにする
set smartindent	  "新しい行を作った時に高度な自動インデントを行う
set smarttab	  "行頭の余白内でTabを打ち込むと，"shiftwidth"の数だけインデントする
set tabstop=4	  "ファイル内の<Tab>が対応する空白の数
set shiftwidth=4  "シフト移動幅
set expandtab     "インサートモードでTabを押した時に空白文字を入力する

" ======================================== 
" Search Settings
" ======================================== 
set ignorecase	" 大文字小文字を区別しない
set smartcase	" 検索文字に大文字がある場合は大文字小文字を区別
set incsearch	" インクリメンタルサーチ
set hlsearch	" 検索マッチテキストハイライト

" ======================================== 
" Edit Settings
" ======================================== 
set fenc=utf-8        " 文字コードをUFT-8に設定
set shiftround	      " <や>でインデントする際に'shiftwidth'の倍数に丸める
set infercase	      " 補完時に大文字小文字を区別しない
set virtualedit=all	  " カーソルを文字が存在しない部分でも動けるようにする
set hidden	          " バッファを閉じる代わりに隠す
set switchbuf=useopen " 新しく開く代わりに既に開いてあるバッファを開く
set showmatch	      " 対応する括弧などをハイライト表示する
set matchtime=3	      " 対応括弧のハイライト時間を3秒にする

" 対応括弧の追加
set matchpairs& matchpairs+=<:>
set matchpairs& matchpairs+=":"
set matchpairs& matchpairs+=':'

" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

set history=200      "Exコマンド記録上限を設定
set pastetoggle=<F5> "pasteオプションのトグルをF5に設定

" ======================================== 
" Display Settings
" ======================================== 
set wrap	    "折り返しあり
set textwidth=0	"自動的に改行が入るのを無効化

" スクリーンベルを無効化
set t_vb=
set novisualbell

" コマンドをステータス行に表示
set showcmd

" ハイライトを有効にする
if &t_Co > 2 || has('gui_running')
    syntax on
endif

" ステータスラインを常に表示する
set ruler

" ======================================== 
" Macro and Key mapping
" ======================================== 
" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>

" ESCを二回押すことでハイライトを消す
nmap <silent> <ESC><ESC> :nohlsearch<CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j,kによる移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" Ctrl + hjklでウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Ctrl + npでバッファ切り替え
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" コマンドラインプロンプトで%:hを手早く入力
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" make,grep などのコマンド後に自動的にQuickFixを開く
"autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep,copen

" QuickFix及びHelpではqでバッファを閉じる
"autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" :eなどでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
	if !isdirectory(a:dir) && (a:force ||
				\ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
		call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
