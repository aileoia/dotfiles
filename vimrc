call plug#begin()

Plug 'alfredodeza/coveragepy.vim'    " Python coverage highlight
Plug 'alfredodeza/pytest.vim'        " Pytest runner plugin
Plug 'davidhalter/jedi-vim'          " Python IDE features
Plug 'dense-analysis/ale'            " Asynchronous linting
Plug 'drewtempelmeyer/palenight.vim' " Color scheme
Plug 'ervandew/supertab'             " Tab completion in insert mode
Plug 'fisadev/vim-isort'             " Sort python imports
Plug 'ludovicchabant/vim-gutentags'  " Tag management
Plug 'majutsushi/tagbar'             " Module/class tag bar
Plug 'mboughaba/i3config.vim'        " Syntax for i3 config file
Plug 'mgedmin/python-imports.vim'    " Auto import for Python
Plug 'preservim/nerdtree'            " File system navigation
Plug 'psf/black', {'tag': '19.10b0'} " Python formatting
Plug 'sheerun/vim-polyglot'          " Color syntax for any language
Plug 'tmhedberg/SimpylFold'          " Python folding
Plug 'tpope/vim-eunuch'              " UNIX commands
Plug 'tpope/vim-fugitive'            " Git support
Plug 'tpope/vim-repeat'              " '.' repeating maps from plugins
Plug 'tpope/vim-sensible'            " Sensible defaults
Plug 'tpope/vim-surround'            " Brackets and parenthesis and such
Plug 'tpope/vim-unimpaired'          " See the help
Plug 'vim-airline/vim-airline'       " Nice status line
Plug 'vim-pandoc/vim-pandoc'         " Pandoc integration
Plug 'vim-pandoc/vim-pandoc-syntax'  " Pandoc (markdown) syntax
Plug 'vim-scripts/bats.vim'          " Syntax highlighting for bats
Plug 'Xuyuanp/nerdtree-git-plugin'   " Git integration for NerdTree
Plug 'zhou13/vim-easyescape/'        " Map jk and kj to <ESC>

if has('nvim')
    Plug 'deoplete-plugins/deoplete-jedi'
    Plug 'deoplete-plugins/deoplete-dictionary'
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} " Semantic highlighting
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    let g:python3_host_prog='/usr/bin/python3'
endif

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
" according to the detected file type.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set autoread            " Automatically reload files when externally changed
set spell               " Spell checking per default
set nowrap              " Disable line wrapping (with unimpaired use yow to toggle)

" Color scheme
" The palenight color scheme comes from a plugin which might not be installed.
" In this case, vim startup should not fail.
colorscheme palenight
let g:airline_theme = "palenight"

" Jedi
if has("nvim")
    let g:jedi#completions_enabled = 0
endif

" Deoplete
if has('nvim')
    let g:deoplete#enable_at_startup = 1
    call deoplete#custom#option('auto_complete_delay', 200)
endif

" Set the buffer-local 'dictionary' for autocompletion
setlocal dictionary+=/usr/share/dict/american-english

" Surround
let b:surround_indent = 1

" Scroll down with supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" Close NERDTree when it is the last open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Ignore temporary files in NERDTree
let NERDTreeIgnore=['\.pyc', '__pycache__', '\.git', '\.eggs', '\.egg-info', '_cache', '\.swp', '\.tox']

" Apply black on save
autocmd BufWritePre *.py execute ':Black'

" Key mappings
let mapleader = " "

" Save and quit quickly
nnoremap <leader>w :w<CR>
nnoremap <leader>q :x<CR>
nnoremap <leader>x :xa<CR>

" Navigation between windows
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>

" Navigation between tabs
nnoremap <C-f> :tabnext<CR>
nnoremap <C-d> :tabprevious<CR>

" NERDTree
nnoremap <C-n> :NERDTreeToggleVCS<CR>


" Fugitive
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gb :Git blame<CR>

" Python Tags
nnoremap <leader>b :TagbarToggle<CR>

" Got to next and previous linting error
nnoremap ]w :ALENext<CR>
nnoremap [w :ALEPrevious<CR>

" Pytest
nnoremap <leader>tt :Pytest project<CR>
nnoremap <leader>tv :Pytest project verbose<CR>
nnoremap <leader>tf :Pytest file verbose<CR>
nnoremap <leader>tll :Pytest function<CR>
nnoremap <leader>tlv :Pytest function verbose<CR>

" Coverage
nnoremap <leader>cs :Coveragepy show<CR>
nnoremap <leader>cr :Coveragepy session<CR>
