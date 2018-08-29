" =======================================
" vim-plug
" =======================================
if has("vim_starting")
  if filereadable("~/.vim/autoload/plug.vim")
    let g:has_vim_plug = 0
    echo "you should download plug-vim"
  else
    let g:has_vim_plug = 1
  endif
endif

if has_vim_plug
  " Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
  call plug#begin('~/.vim/plugged')

  " Make sure you use single quotes
  " Shorthand notation
  Plug 'tpope/vim-surround'
  Plug 'junegunn/vim-easy-align'
  Plug 'glidenote/memolist.vim'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'luochen1990/rainbow'
  Plug 'scrooloose/nerdtree'

  if v:version >= 703
      Plug 'Shougo/unite.vim'
  endif

  if v:version >= 704
      Plug 'honza/vim-snippets'
      Plug 'SirVer/ultisnips'
  endif

  " Initialize plugin system
  call plug#end()
endif

" =======================================
" Auto Command
" =======================================
" release autogroup in MyAutoCmd
augroup MyAutoCmd
	autocmd!
augroup END

autocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" =======================================
" System Settings
" =======================================
" マウスの設定
if has('mouse')
	set mouse=a
endif

" コマンドライン補完の強化
set wildmenu

" =======================================
" Indent Settings
" =======================================
set autoindent	  "新しい行のインデントを現在行と同じにする
set smartindent	  "新しい行を作った時に高度な自動インデントを行う
set smarttab	  "行頭の余白内でTabを打ち込むと，"shiftwidth"の数だけインデントする
set tabstop=4	  "ファイル内の<Tab>が対応する空白の数
set shiftwidth=4  "シフト移動幅
set expandtab     "インサートモードでTabを押した時に空白文字を入力する

" =======================================
" Search Settings
" =======================================
set ignorecase	" 大文字小文字を区別しない
set smartcase	" 検索文字に大文字がある場合は大文字小文字を区別
set incsearch	" インクリメンタルサーチ
set hlsearch	" 検索マッチテキストハイライト

" =======================================
" Encoding
" =======================================
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set fenc=utf-8        " 文字コードをUFT-8に設定

" =======================================
" Edit Settings
" =======================================
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

" =======================================
" Display Settings
" =======================================
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

" =======================================
" Macro and Key mapping
" =======================================
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

" 日本語入力がオンのままでも使えるコマンド(Enterキーは必要)
inoremap <silent> ｊｊ <ESC>
nnoremap あ a
nnoremap い i
nnoremap お o

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

" =======================================
" plugin-memolist.vim
" =======================================
let g:memolist_path = "$HOME/GoogleDrive/memo"

nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>

" suffix type (default markdown)
let g:memolist_memo_suffix = "markdown"

" date format (default %Y-%m-%d %H:%M)
let g:memolist_memo_date = "%Y-%m-%d %H:%M"

" tags prompt (default 0)
let g:memolist_prompt_tags = 0

" categories prompt (default 0)
let g:memolist_prompt_categories = 0

" use qfixgrep (default 0)
let g:memolist_qfixgrep = 0

" use vimfler (default 0)
let g:memolist_vimfiler = 0

" remove filename prefix (default 0)
let g:memolist_filename_prefix_none = 0

" use unite (default 0)
let g:memolist_unite = 1

" use arbitrary unite source (default is 'file')
let g:memolist_unite_source = "file"

" use arbitrary unite option (default is empty)
let g:memolist_unite_option = "-start-insert"

" use denite (default 0)
let g:memolist_denite = 0

" use arbitrary denite source (default is 'file_rec')
let g:memolist_denite_source = "file_rec"

" use arbitrary denite option (default is empty)
let g:memolist_denite_option = ""

" use various Ex commands (default '')
let g:memolist_ex_cmd = ''

" use delimiter of array in yaml front matter (default is ' ')
let g:memolist_delimiter_yaml_array = ' '

" use when get items from yaml front matter
" first line string pattern of yaml front matter (default "==========")
let g:memolist_delimiter_yaml_start = "=========="

" last line string pattern of yaml front matter (default "- - -")
let g:memolist_delimiter_yaml_end  = "- - -"

" =======================================
" plugin-vim-easy-align
" =======================================
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" =======================================
" plugin-ultisnips
" =======================================
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" =======================================
" plugin-vim-indent-guides
" =======================================
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size  = 1
let g:indent_guides_start_level = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=darkgrey ctermbg=grey
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=grey ctermbg=lightgrey

" =======================================
" plugin-rainbow
" =======================================
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle


" ========================================
" plugin-nerdtree
" ========================================
map <C-o> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" ========================================
" plugin-unite
nnoremap <silent> gub :<C-u>Unite buffer<CR>
nnoremap <silent> guf :<C-u>Unite file<CR>
nnoremap <silent> guu :<C-u>Unite file buffer<CR>
nnoremap <silent> gur :<C-u>Unite register<CR>
nnoremap <silent> gum :<C-u>Unite mapping<CR>
nnoremap <silent> guv :<C-u>Unite vimgrep -auto-preview -buffer-name=search-buffer -vertical<CR>
nnoremap <silent> gur :<C-u>UniteResume -buffer-name=search-buffer<CR>
