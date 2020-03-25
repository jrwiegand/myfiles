set nocompatible                      " Make Vim more useful
colorscheme material                  " Set color scheme!
set clipboard=unnamed                 " Use the OS clipboard by default (on versions compiled with `+clipboard`)
set wildmenu                          " Enhance command-line completion
set backspace=indent,eol,start        " Allow backspace in insert mode
set ttyfast                           " Optimize for fast terminal connections
set gdefault                          " Add the g flag to search/replace by default
set encoding=utf-8 nobomb             " Use UTF-8 without BOM
let mapleader=","                     " Change mapleader

set backupdir=~/.vim/backups          " backups
set directory=~/.vim/swaps            " swapfiles and
if exists("&undodir")
        set undodir=~/.vim/undo       " undo history
endif

set viminfo+=!                        " make sure vim history works
map <C-J> <C-W>j<C-W>_                " open and maximize the split below
map <C-K> <C-W>k<C-W>_                " open and maximize the split above
set wmh=0                             " reduces splits to a single line

set exrc                              " Enable per-directory .vimrc files
set secure                            " disable unsafe commands in them

syntax on                             " Enable syntax highlighting
set tabstop=4                         " Make tabs as wide as two spaces
set number                            " Enable line numbers
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_  " Show “invisible” characters
set list
set hlsearch                          " Highlight searches
set ignorecase                        " Ignore case of searches
set incsearch                         " Highlight dynamically as pattern is typed
set laststatus=2                      " Always show status line
set modeline                          " Respect modeline in files
set modelines=4
set mouse=a                           " Enable mouse in all modes
set noerrorbells                      " Disable error bells
set nostartofline                     " Don’t reset cursor to start of line when moving around.
set ruler                             " Show the cursor position
set shortmess=atI                     " Don’t show the intro message when starting Vim
set showmode                          " Show the current mode
set title                             " Show the filename in the window titlebar
set showcmd                           " Show the (partial) command as it’s being typed

set scrolloff=3                       " Start scrolling three lines before the horizontal window border

set rtp+=/usr/local/opt/fzf           " Turn on fuzzy finder

" Strip trailing whitespace (,ss)
function! StripWhitespace()
        let save_cursor = getpos(".")
        let old_query = getreg('/')
        :%s/\s\+$//e
        call setpos('.', save_cursor)
        call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

noremap <leader>W :w !sudo tee % > /dev/null<CR> " Save a file as root (,W)

" Automatic commands
if has("autocmd")
  filetype on " Enable file type detection
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript " Treat .json files as .js
endif

let g:python_host_prog = "/usr/local/bin/python2"
let g:python3_host_prog = "/usr/local/bin/python3"

