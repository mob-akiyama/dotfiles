syntax on "コードの色分け
filetype on
filetype plugin on
filetype indent on

set nocompatible
set noautoindent
set wildmenu wildmode=list:full
set pastetoggle=<F11>
set number
set backspace=start,eol,indent
set whichwrap=b,s,[,],,~
set cursorline
set ruler
set title "編集中のファイル名を表示
set noswapfile

" Ctrl+cにESCを割り当て
inoremap <C-c> <Esc>

"highlight Normal ctermbg=black ctermfg=grey
"highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
"highlight CursorLine term=none cterm=none ctermfg=none ctermbg=darkgray

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  "call neobundle#rc(expand('~/.vim/bundle'))
  call neobundle#begin(expand('~/.vim/bundle/'))
    NeoBundle 'git://github.com/Shougo/clang_complete.git'
    NeoBundle 'git://github.com/Shougo/echodoc.git'
    NeoBundle 'git://github.com/Shougo/neocomplcache.git'
    NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
    NeoBundle 'git://github.com/Shougo/unite.vim.git'
    NeoBundle 'git://github.com/Shougo/vim-vcs.git'
    NeoBundle 'git://github.com/Shougo/vimfiler.git'
    NeoBundle 'git://github.com/Shougo/vimshell.git'
    NeoBundle 'git://github.com/Shougo/vinarise.git'
    NeoBundle 'davidhalter/jedi-vim'
    NeoBundle 'Flake8-vim'
    NeoBundle 'hynek/vim-python-pep8-indent'
    NeoBundle 'mrk21/yaml-vim'
    "NeoBundlh 'chase/vim-ansible-yaml'
    NeoBundle 'terryma/vim-multiple-cursors'
    NeoBundle 'vim-scripts/taglist.vim'
    NeoBundle 'ctrlpvim/ctrlp.vim'
    NeoBundle 'thinca/vim-quickrun'
  call neobundle#end()
endif

if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif


"set tabstop=4 "インデントをスペース4つ分に設定
"set shiftwidth=4 " タブを挿入するときの幅
"set noexpandtab " タブをタブとして扱う(スペースに展開しない)
"set softtabstop=0
"set smartindent "オートインデント

set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る

""クリップボードをWindowsと連携する
set clipboard=unnamed

"インクリメンタルサーチを行う
set incsearch

"閉括弧が入力された時、対応する括弧を強調する
set showmatch

""新しい行を作った時に高度な自動インデントを行う
set smarttab

set formatoptions-=ro

"保存時に自動でチェック
let g:PyFlakeOnWrite = 1

"解析種別を設定
let g:PyFlakeCheckers = 'pep8,mccabe,pyflakes'

"McCabe複雑度の最大値
let g:PyFlakeDefaultComplexity=10

"visualモードでQを押すと自動で修正
let g:PyFlakeRangeCommand = 'Q'

"netrw
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
function! ToggleVExplorer()
	if !exists("t:netrw_bufnr")
		exec '1wincmd w'
		20Vexplore
		let t:netrw_bufnr = bufnr("%")
		return
	endif
	let win = bufwinnr(t:netrw_bufnr)
	if win != 1
		let cur = winnr()
		exe win . 'wincmd w'
		close
		exe cur . 'wincmd w'
	endif
	unlet t:netrw_bufnr
endfunction
map <silent> <leader>e :call ToggleVExplorer()<cr><c-w>p

"taglist
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
map <silent> <leader>E :TlistToggle<cr>

"ctrlp
function! CtrlP_OpenAtCenter(action, line)
	let cw = bufwinnr('.')
	for n in range(0, bufnr('$'))
		let bw = bufwinnr(n)
		if bw == cw && buflisted(n)
			exe bw . 'wincmd w'
			break
		endif
	endfor
	call call('ctrlp#acceptfile', [a:action, a:line])
endfunction
let g:ctrlp_open_func = {'files': 'CtrlP_OpenAtCenter'}

nnoremap <silent> r :QuickRun
