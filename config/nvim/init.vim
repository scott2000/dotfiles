" This vimrc should work for both Vim and Neovim
" Created by Scott Taylor

" Trigger FZF with <C-p> (requires fzf-vim)
nnoremap <C-p> :FZF<Cr>

" Set up vim-easymotion
let g:EasyMotion_smartcase = 1
nnoremap S <Plug>(easymotion-s)
nnoremap W <Plug>(easymotion-w)
nnoremap E <Plug>(easymotion-e)
nnoremap B <Plug>(easymotion-b)

let mapleader = ' '       " leader is space

" Prevent accidental triggering of default meaning for leader
" nnoremap <Leader> <Nop>

" Plain Vim has some weird glitches if mapping <Esc>
if has('nvim')
    " Disable search highlighting with <Esc> and clear bottom line
    nnoremap <Esc> :nohlsearch<CR>:<BS>
endif

" Use gs to sort in visual mode
vnoremap gs :sort<CR>

" Disable search highlighting with <Leader>+ (as a backup)
nnoremap <Leader>+ :nohlsearch<CR>:<BS>

" Disable U to prevent mistakes
nnoremap U <Nop>

" Make & keep flags for substitutions
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" A slight hack to make j and k work with wrapping, but also work with
" relative numbers and jumps
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
xnoremap <expr> j v:count ? 'j' : 'gj'
xnoremap <expr> k v:count ? 'k' : 'gk'

" Use Control and j/k to scroll
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>
vnoremap <C-j> <C-d>
vnoremap <C-k> <C-u>

" Use jk for escape when necessary
inoremap jk <Esc>

" For accidentally pressing Meta instead of Control
nnoremap <M-j> <C-d>
nnoremap <M-k> <C-u>
vnoremap <M-j> <C-d>
vnoremap <M-k> <C-u>
inoremap <M-n> <C-n>
inoremap <M-p> <C-p>

" Backslash to toggle buffers
nnoremap \ <C-^>

" Clear a line without removing the newline
nnoremap <silent> <Leader>d cc<Esc>

" Next and previous tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT

set relativenumber      " show relative line numbers
set number              " show absolute number on current line

set hidden              " allow hidden buffers
set switchbuf=usetab    " switch to buffer if already open anywhere
set splitright          " open splits on the right side

set path+=**            " search recursively with find

set ignorecase          " ignore the case when searching
set smartcase           " only ignore case when no caps included
set wildignorecase      " ignore case when completing file names
set infercase           " when completing names, infer case changes

if has('nvim')
    set selection=exclusive " don't include the last character in selections
endif

" Highlight column 81
set colorcolumn=81

" Ignored file types
set wildignore+=tags
set wildignore+=*.pyc,*.class,*.iml
set wildignore+=*.out,*.swp,*.bak
set wildignore+=*.tar.*,*.zip
set wildignore+=*/.git/**/*
set wildignore+=*/target/**/*
set wildignore+=*/out/**/*
set wildignore+=*/dist/**/*
set wildignore+=*/dist-newstyle/**/*
set wildignore+=*/node_modules/**/*

" Make @<macro> work correctly on visual selections
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Indentation and folding
set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4        " number of spaces to use for autoindent
set expandtab           " tabs are spaces
set autoindent          " copy indent from the previous line

" Set defaults for moving around text
set whichwrap+=<,>,[,]
set backspace=indent,eol,start

" Search highlighting
set incsearch
set hlsearch

" Display options
set display+=lastline
set encoding=utf-8
set linebreak
set scrolloff=5
set sidescrolloff=5
set wrap
set title
set ruler
set background=dark
set tabpagemax=25

set wildmenu            " show autocomplete menu
set showcmd             " show command in bottom bar
set lazyredraw          " redraw the screen less when it isn't needed
" set noshowmode        " hide "-- INSERT --"

set laststatus=2        " always show status line
set noerrorbells        " shhhh!
" set mouse=nich        " enable the mouse, but not visual selection
set mouse=ch            " only enable the mouse in help files
set clipboard=unnamedplus

set autoread            " re-read files if not modified
set history=1000        " long undo history
set nrformats-=octal    " dont interpret leading 0 as octal

set ttimeoutlen=10      " for esacpe timeout in vim
set secure              " turn on additional security
set nomodeline          " turn off modelines for security

" Autogroup configuration settings
augroup vimrcgroup
    " Clear these settings if the file is sourced again
    autocmd!

    " File-specific configuration options
    autocmd FileType haskell,sh,fish,javascript,typescript,typescriptreact,text,markdown,nix setlocal
      \ shiftwidth=2 tabstop=2 softtabstop=2
    autocmd BufEnter Makefile setlocal noexpandtab

    " Special syntax highlighting
    autocmd FileType haskell syn match hsTypedef '\<pattern\>'

    " Treat .c and .h files as C, not C++
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c

    " Treat .html.hbs files as HTML
    autocmd BufRead,BufNewFile *.html.hbs set filetype=html

    " Toggle ignorecase on insert for better <C-n> completion
    autocmd InsertEnter * set noignorecase
    autocmd InsertLeave * set ignorecase
augroup END
