" 
" 
" RPINDER .VIMRC FILE 
"  http://github.com/rpinder
" 
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

Plug 'scrooloose/nerdtree'                       " File browsing
Plug 'Xuyuanp/nerdtree-git-plugin' 
Plug 'ctrlpvim/ctrlp.vim'                        " Fuzzy file browinsg
Plug 'vim-airline/vim-airline'                   " status line
Plug 'vim-airline/vim-airline-themes' 
Plug 'chriskempson/base16-vim'                   " colorscheme
Plug 'neomake/neomake'                           " linter/maker
Plug 'dojoteef/neomake-autolint' 
Plug 'mhinz/vim-startify'                        " startscreen showing most recent files
Plug 'tpope/vim-fugitive'                        " git
Plug 'tpope/vim-surround'                        " easily change surrounding punctuation
Plug 'tpope/vim-commentary'                      " comment plugin
Plug 'valloric/youcompleteme'                    " autocomplete
Plug 'majutsushi/tagbar'                         " class outline viewer
Plug 'jiangmiao/auto-pairs'                      " insert r delete brackets, parens, quotes in pair
Plug 'vim-scripts/a.vim'                         " switch between header and corresponding file
Plug 'airblade/vim-gitgutter'                    " shows git diff in the gutter

call plug#end()                                  " Add plugins to &runtimepath

set encoding=utf8
set laststatus=2                                 " Always show statusline

if has('folding')
  if has('window')
    set fillchars=vert:│
  endif
endif

" Colors 
set t_Co=256                                     " terminal colours look like gvim
syntax enable                                    " enable symtax processing
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
colorscheme base16-ocean

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
set cursorline                                   " highlight current line
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
  set nobackup                                   " don't create root owned files
  set nowritebackup 
else
  set backupdir=~/local/.vim/tmp/backup
  set backupdir+=~/.vim/tmp/backup               " keep backup files out of the way
  set backupdir+=.
endif

if exists('$SUDO_USER')
  set noswapfile                                 " don't create root owned files
else
  set directory=~/local/.vim/tmp/swap//
  set directory+=~/.vim/tmp/swap//               " keep swap files out of the way

  set directory+=.
endif

if has('persistent_undo')
  if exists('$SUDO_USER')
    set noundofile                               " don't create root owned files
  else
    set undodir=~/local/.vim/tmp/undo
    set undodir+=~/.vim/tmp/undo                 " keep undo files out of the way
    set undodir+=.
    set undofile                                 " actually use undo files 
  endif
endif

if has('viminfo')
  if exists('$SUDO_USER')
    set viminfo=                                  " don't create root-owned files
  else
    if isdirectory('~/local/.vim/tmp')
      set viminfo+=n~/local/.vim/tmp/viminfo
    else
      set viminfo+=n~/.vim/tmp/viminfo           " override ~/.viminfo default
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
    set viewdir=~/.vim/tmp/view                  " override ~/.vim/view default
  endif
  set viewoptions=cursor,folds                   " save/restore just these (with ':{mk, loadview#)
endif

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 " ruby files have 2 tabs
autocmd FileType vim setlocal let b:autopairs_loaded=1

" Movement
" move vertically by visual line
nnoremap j gj 
nnoremap k gk

" Airline 
let g:airline_theme='base16'
let g:airline_powerline_fonts = 1

" CTRLP
let g:ctrlp_map =''

" YCM
let g:ycm_confirm_extra_conf = 0

" Neomake
let g:neomake_c_enabled_makers = [] " ycm handles c and c++
let g:neomake_cpp_enabled_makers = [] 

" leader
map <space> <leader>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>p :CtrlP<cr>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>T :TagbarToggle<CR>
nnoremap <leader>t :CtrlPTag<cr>
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>w :w<cr>
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>lc :lclose<cr>
nnoremap <leader>ll :ll<cr>
autocmd FileType c nnoremap <leader>ca :A<cr>
autocmd FileType python nnoremap <leader>cr :!python %<cr>
