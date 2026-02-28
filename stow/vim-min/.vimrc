" vim-min: server-safe, fast, no plugins
set nocompatible
set encoding=utf-8
syntax on
filetype plugin indent on

" UX
set number
set ruler
set showcmd
set nowrap
set backspace=indent,eol,start
set hidden
set mouse=

" Indent (2 spaces by default)
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Navigation
set scrolloff=3
set sidescrolloff=5
set splitbelow
set splitright

" Persistent undo (safe if directory exists)
if exists("+undofile")
  set undofile
  if !isdirectory(expand("~/.vim/undo"))
    silent! call mkdir(expand("~/.vim/undo"), "p")
  endif
  set undodir=~/.vim/undo
endif

" Leader
let mapleader=" "

" Quick save/quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>

" Clear search highlight
nnoremap <leader>/ :nohlsearch<CR>

" Clipboard: keep conservative for SSH servers
set clipboard=
