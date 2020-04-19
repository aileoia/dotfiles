call plug#begin()

Plug 'davidhalter/jedi-vim' " Python IDE features
Plug 'dense-analysis/ale'  " Async linting
Plug 'ervandew/supertab'  " Tabcompletion in insert mode
Plug 'tpope/vim-eunuch'  " UNIX commands
Plug 'tpope/vim-fugitive'  " Git support
Plug 'tpope/vim-sensible'  " Sensible defaults
Plug 'tpope/vim-surround'  " Brackets and parenthesis and such

call plug#end()

if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set autoread            " Automatically reload files when externally changed
set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)


let mapleader = " "

" Navigation between windows
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>

" Naviation between tabs
nnoremap <tab> :tabnext<CR>
nnoremap <S-tab> :tabprevious<CR>


" Fugitive
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gp :Git push<CR>
