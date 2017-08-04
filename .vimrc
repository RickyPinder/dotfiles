"
"
" RPINDER .VIMRC FILE
"  http://github.com/rpinder
"

" Plugins

" vim-plug (https://github.com/junegunn/vim-plug) settings
" Automatically install vim-plug and run PlugInstall if vim-plug not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/a.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mtth/scratch.vim'
Plug 'dylanaraps/wal.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install -all' }
Plug 'junegunn/fzf.vim'

call plug#end()

if has("gui_running")
    set guioptions+=c
    set guioptions+=R
    set guioptions-=m
    set guioptions-=r
    set guioptions-=b
    set guioptions-=T
    set guioptions-=R
    set guioptions-=L
    set guioptions-=e
    set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline\ 11
endif

set encoding=utf8
set laststatus=2                                 " Always show statusline

if has('folding')
    if has('window')
        set fillchars=vert:│
    endif
endif

if has('autocmd')
    autocmd FileType c nnoremap <buffer> <localleader>ca :A<cr>
    autocmd FileType cpp nnoremap <buffer> <localleader>ca :A<cr>
    autocmd FileType python nnoremap <buffer> <localleader>cr :!python %<cr>
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 " ruby files have 2 tabs
    autocmd FileType vim let b:AutoPairs = {'(':')', "'":"'", '[':']', '{':'}'}
end

" Colors
set t_Co=256                                     " terminal colours look like gvim
syntax enable                                    " enable symtax processing
colorscheme wal

" Spaces & Tabs
set tabstop=4                                    " number of visual spaces per TAB
set softtabstop=4                                " number of spaces in tab when editing
set expandtab                                    " tabs are spaces
set smarttab
set shiftwidth=4


" UI Config
set number                                       " show line numbers
set relativenumber                               " Relative line numbers
set showcmd                                      " show command in bottom bar
"set cursorline                                   " highlight current line
filetype indent on                               " load filetype-specific ident files
set wildmenu                                     " visual autocomplete for command menu
set lazyredraw                                   " redraw only when we need to
set showmatch                                    " highlight matching [{()}]
set laststatus=2                                 " Always show statusline
highlight CursorLineNr ctermfg=yellow            " Current line number is yellow

" Searching
set incsearch                                    " search as characters are entered
set hlsearch                                     " highlist matches

" Folding
set foldenable                                   " enable folding
set foldlevelstart=10                            " open most folds by default
set foldnestmax=10                               " 10 nested fold max
set foldmethod=indent                            " fold based on indent level

" stuff
set autoindent                                   " maintains indent of current line

noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>

if exists('$SUDO_USER')
    set nobackup                                 " don't create root owned files
    set nowritebackup
else
    set backupdir=~/local/.vim/tmp/backup
    set backupdir+=~/.vim/tmp/backup             " keep backup files out of the way
    set backupdir+=.
endif

if exists('$SUDO_USER')
    set noswapfile                               " don't create root owned files
else
    set directory=~/local/.vim/tmp/swap//
    set directory+=~/.vim/tmp/swap//             " keep swap files out of the way

    set directory+=.
endif

if has('persistent_undo')
    if exists('$SUDO_USER')
        set noundofile                           " don't create root owned files
    else
        set undodir=~/local/.vim/tmp/undo
        set undodir+=~/.vim/tmp/undo             " keep undo files out of the way
        set undodir+=.
        set undofile                             " actually use undo files
    endif
endif

if has('viminfo')
    if exists('$SUDO_USER')
        set viminfo=                             " don't create root-owned files
    else
        if isdirectory('~/local/.vim/tmp')
            set viminfo+=n~/local/.vim/tmp/viminfo
        else
            set viminfo+=n~/.vim/tmp/viminfo     " override ~/.viminfo default
        endif

        if !empty(glob('~/.vim/tmp/viminfo'))
            if !filereadable(expand('~/.vim/tmp/viminfo'))
                echoerr 'warning ~/.vim/tmp/viminfo exists but is not readable'
            endif
        endif
    endif
endif

if has('mksession')
    if isdirectory('~/local/.vim/tmp')
        set viewdir=~/loca/.vim/tmp/view
    else
        set viewdir=~/.vim/tmp/view              " override ~/.vim/view default
    endif
    set viewoptions=cursor,folds                 " save/restore just these (with ':{mk, loadview#)
endif

" Movement
" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Airline
let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1

" Startify
let g:startify_list_order = [
            \['   Bookmarks'],
            \'bookmarks',
            \['   Recent files'],
            \'files',
            \['   Recent files in current dir'],
            \'dir',
            \['   Sessions'],
            \'sessions',
            \['   Commands'],
            \'commands'
            \]
let g:startify_files_number = 5
let g:startify_update_oldfiles = 1
let g:startify_bookmarks = [ '~/dotfiles/vimrc', '~/dotfiles/zshrc', '~/code/']

" FZF
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>

" jk or kj to escape insert mode
inoremap jk <Esc>
inoremap kj <Esc>

" leader
map <space> <leader>

" build in vim keybinds
nnoremap <leader>w :w<cr>
nnoremap <leader><space> :nohlsearch<CR>
