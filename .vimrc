" ======================================== 
" NeoBundle Settings
" ======================================== 
set nocompatible
filetype off
if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim.git
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" NeoBundle自身をNeoBundleで管理する
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache'
"NeoBundle 'Shougo/neosnippet'

filetype plugin on
filetype indent on

" NeoBundle Installation check
NeoBundleCheck

" ======================================== 
" Auto Command
" ======================================== 
" release autogroup in MyAutoCmd
augroup MyAutoCmd
	autocmd!
augroup END

" 入力モード時，ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
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
" Indentt Settings
" ======================================== 
set autoindent	"新しい行のインデントを現在行と同じにする
set shiftwidth=4	"シフト移動幅
set smartindent	"新しい行を作った時に高度な自動インデントを行う
set smarttab	"行頭の余白内でTabを打ち込むと，"shiftwidth"の数だけインデントする
set tabstop=4	"ファイル内の<Tab>が対応する空白の数

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
set shiftround	" <や>でインデントする際に'shiftwidth'の倍数に丸める
set infercase	" 補完時に大文字小文字を区別しない
set virtualedit=all	" カーソルを文字が存在しない部分でも動けるようにする
set hidden	" バッファを閉じる代わりに隠す
set switchbuf=useopen	" 新しく開く代わりに既に開いてあるバッファを開く
set showmatch	" 対応する括弧などをハイライト表示する
set matchtime=3	" 対応括弧のハイライト時間を3秒にする

" 対応括弧の追加
set matchpairs& matchpairs+=<:>
set matchpairs& matchpairs+=":"
set matchpairs& matchpairs+=':'

" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
	set clipboard& clipboard+=unnamedplus
else
	" set clipboard& clipboard+=unnamed,autoselect 2013-06-24 10:00 autoselect 削除
	set clipboard& clipboard+=unnamed
endif

" ======================================== 
" Display Settings
" ======================================== 
set nowrap	" 折り返しなし
set textwidth=0	"自動的に改行が入るのを無効化
"set colorcolumn=80	" その代わり80文字目にラインを入れる

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
" Color Settings
" ======================================== 

" ======================================== 
" Macro and Key mapping
" ======================================== 
" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>

" 括弧入力時その中に戻る
inoremap {} {}<Left>
inoremap [] []<Left>
inoremap () ()<Left>
inoremap “” “”<Left>
inoremap ” ”<Left>
inoremap <> <><Left>
inoremap “ “<Left>

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
"nnoremap j gj
"nnoremap k gk

" vを二回で行末まで選択
vnoremap v $h

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

" make,grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep,copen

" QuickFix及びHelpではqでバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" :eなどでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
	if !isdirectory(a:dir) && (a:force ||
				\ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
		call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

" ========================================
" Plugin Settings
" ========================================
" ========================================
" neocomplcache
" ========================================
" Disable AutoComplPop.
"let g:acp_enableAtStartup = 0
" 起動時に有効化
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 5
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_auto_completion_start_length = 5
" ポップアップメニューで表示される候補の数
let g:neocomplcache_max_list = 20
" シンタックスをキャッシュするときの最小文字長
let g:neocomplcache_min_syntax_length = 3

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1

" ファイルタイプごとにディクショナリを設定
let g:neocomplcache_dictionary_filetype_lists = {
			\ 'default' : '',
			\ 'vimshell' : $HOME.'/.vimshell_hist',
			\ 'scheme' : $HOME.'/.gosh_completions'
			\ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
" 補完のキャンセル
inoremap <expr><C-g> neocomplcache#undo_completion()
" 補完候補の共通する部分を補完
inoremap <expr><C-l> neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return neocomplcache#smart_close_popup() . "\<CR>"
	" For no inserting <CR> key.
	"return pumvisible() ?
	neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
"\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left> neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up> neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down> neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
   let g:neocomplcache_omni_patterns = {}
endif

let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

"" ========================================
"" Snippets Settings
"" ========================================
"" Plugin key-mappings.
"imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"smap <C-k>     <Plug>(neosnippet_expand_or_jump)
"
"" SuperTab like snippets behavior.
"imap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ?  "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
"smap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ?  "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
"
"" For snippet_complete marker.
"if has('conceal')
"	set conceallevel=2 concealcursor=i
"endif
"
"" Enable snipMate compatibility feature.
"let g:neosnippet#enable_snipmate_compatibility = 1
"
"" Tell Neosnippet about the other snippets
"let g:neosnippet#snippets_directory='~/.vim/snippets'
