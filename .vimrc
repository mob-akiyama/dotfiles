syntax on "コードの色分け
filetype on

set nosmartindent "C言語向けのインデントを無効に
set nocompatible "vi互換を無効にする
set wildmenu wildmode=list:full "ファイル保管をオンにする
set pastetoggle=<F11> "自動インデントを一時的に無効にする
set number "行番号の表示を有効にする
set backspace=start,eol,indent "インサートモード時にバックスペースを使う
set cursorline "カーソル行の強調表示
set ruler "エディタ右下にルーラーを表示
set title "編集中のファイル名を表示
set noswapfile "swpファイルを作成しない
set nobackup "バックアップを作成しない
set nowritebackup
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "大文字で検索されたら対象を大文字限定にする
set wrapscan "検索時に最後まで行ったら最初に戻る
set incsearch "インクリメンタルサーチを行う
set nowrap "行を折り返さない
set clipboard=unnamed "クリップボードをWindowsと連携する
set showmatch "閉括弧が入力された時、対応する括弧を強調する
set formatoptions-=ro "継続行の自動コメントアウトを無効にする
set tabstop=4 "<TAB>を含むファイルを開いた際、<TAB>を何文字の空白に変換するかを設定
set softtabstop=4 "キーボードで<TAB>を入力した際、<TAB>を何文字の空白に変換するかを設定
set shiftwidth=2 "vimが自動でインデントを行った際、設定する空白数
set autoindent "自動インデントを無効に
set expandtab "タブを空白に設定する
set hlsearch "検索マッチテキストをハイライト
set infercase "補完時に大文字小文字を区別しない
"set list "不可視文字の可視化
set textwidth=0 "自動的に改行が入るのを無効化
set colorcolumn=80 "その代わり80文字目にラインを入れる
set mouse=n
set ttymouse=xterm2

vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

"Ctrl+cにESCを割り当て
inoremap <C-c> <Esc>

"highlight Normal ctermbg=black ctermfg=grey
"highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
"highlight CursorLine term=none cterm=none ctermfg=none ctermbg=darkgray

"Vimを最強のPython開発環境にする2
"http://lambdalisue.hatenablog.com/entry/2013/06/23/071344
augroup MyAutoCmd
    autocmd!
augroup END

let $PATH = "~/.pyenv/shims:".$PATH

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
    "call neobundle#rc(expand('~/.vim/bundle'))
    call neobundle#begin(expand('~/.vim/bundle/'))
        NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
        NeoBundle 'git://github.com/Shougo/clang_complete.git'
        NeoBundle 'git://github.com/Shougo/echodoc.git'
        "NeoBundle 'git://github.com/Shougo/neocomplcache.git'
        "NeoBundle 'git://github.com/Shougo/unite.vim.git'
        NeoBundle 'git://github.com/Shougo/vim-vcs.git'
        NeoBundle 'git://github.com/Shougo/vimfiler.git'
        NeoBundle 'git://github.com/Shougo/vimshell.git'
        NeoBundle 'git://github.com/Shougo/vinarise.git'
        "NeoBundle 'andviro/flake8-vim'
        "NeoBundle 'scrooloose/syntastic'
        NeoBundle 'davidhalter/jedi-vim'
        NeoBundle 'nvie/vim-flake8'
        NeoBundle 'hynek/vim-python-pep8-indent'
        NeoBundle 'mrk21/yaml-vim'
        "NeoBundlh 'chase/vim-ansible-yaml'
        NeoBundle 'terryma/vim-multiple-cursors'
        NeoBundle 'vim-scripts/taglist.vim'
        NeoBundle 'ctrlpvim/ctrlp.vim'
        NeoBundle 'thinca/vim-quickrun'
        NeoBundle 'junegunn/seoul256.vim'
        "NeoBundle 'lambdalisue/vim-pyenv'
    call neobundle#end()
endif

NeoBundleLazy 'lambdalisue/vim-pyenv', {
    \ 'depends': ['davidhalter/jedi-vim'],
    \ 'autoload': {
    \     'filetypes': ['python', 'python3'],
    \ }
\ }

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

"let g:PyFlakeOnWrite = 1 "保存時に自動でチェック
"let g:PyFlakeCheckers = 'pep8,mccabe,pyflakes' "解析種別を設定
"let g:PyFlakeDefaultComplexity=10 "McCabe複雑度の最大値
"let g:PyFlakeRangeCommand = 'Q' "visualモードでQを押すと自動で修正
"let g:syntastic_python_checkers = ["flake8"]
autocmd BufWritePost *.py call Flake8() "バッファー保存時にvim-flake8を実行する

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

"colo seoul256
filetype plugin on
filetype indent on
