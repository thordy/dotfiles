set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'godlygeek/tabular'
Plugin 'flazz/vim-colorschemes'

call vundle#end()            " required
filetype plugin indent on    " required

colorscheme 256-jungle
set background=dark

set nocompatible

let mapleader=","   " Set leader key

" Indentation
set tabstop=4       " Number of visual spaces per <tab>
set softtabstop=4   " Number of spaces in <tab> when editing
set smarttab
set shiftwidth=0
set expandtab       " Tabs are spaces

" Searching
set incsearch       " Incremental search
set ignorecase      " Ignore case ...
set smartcase       " .. unless case is specified
set hlsearch        " Highlight search
" Disable search highlight with <Leader><space>
nnoremap <leader><space> :nohlsearch<CR>

set showmatch       " Show matching brackets
set number          " Show line numbers
set autoindent      " Auto indent lines
set ruler           " Show line number in status
set cmdheight=2     " Set height of command
set scrolloff=5     " Keep 5 lines above/below
set wildmenu        " Tab completion in menu
set wildmode=list:longest
set laststatus=2    " Always show status line
set cursorline      " Highlight current line

" Mouse support in console
set mouse=a

" Fix backspace
set bs=2

" Syntax highlighting
filetype on
filetype indent on
filetype plugin on
syntax enable

" Map jj to escape in insert mode
inoremap jj <Esc>
nnoremap JJJJ <Nop>

" Make up/down on wrapped lines behave normal
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Move lines up/down with <alt-up/down> in normal and insert mode
" == is used to reindent lines to correct indentation
"nnoremap ?[1;3B :m .+1<CR>==
"nnoremap ?[1;3A :m .-2<CR>==
"inoremap ?[1;3B <Esc>:m .+1<CR>==gi
"inoremap ?[1;3A <Esc>:m .-2<CR>==gi


" Implementation of smart home to ignore tab/space on <home>
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
imap <silent> <Home> <C-O><Home>

" Easier window cycling using <ctrl>-h/j/k/l
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

