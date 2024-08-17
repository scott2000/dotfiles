" This vimrc should work for both Vim and Neovim (requires vim-plug)
" Created by Scott Taylor

" Plugin installation {{{

" If using Neovim, place it in a different folder
if has('nvim')
    call plug#begin(stdpath('data') . '/plugged')
else
    set nocompatible
    call plug#begin('~/.vim/plugged')
endif

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'peterrincker/vim-argumentative'
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'michaeljsmith/vim-indent-object'
Plug 'dense-analysis/ale'
Plug 'romainl/vim-qf'
Plug 'rust-lang/rust.vim'

Plug 'pangloss/vim-javascript'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'whonore/Coqtail'
Plug 'rightson/vim-p4-syntax'
Plug 'dmix/elvish.vim', { 'on_ft': ['elvish']}
Plug 'elixir-editors/vim-elixir'
Plug 'avm99963/vim-jjdescription'
Plug 'LnL7/vim-nix'

" Initialize plugin system
call plug#end()

" }}}
" Plugin setup {{{

" EasyAlign setup
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Airline setup
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''

" Netrw setup
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3

" ALE setup {{{

" Use /bin/sh for shell
let g:ale_shell = '/bin/sh'

" Set formatting
let g:airline#extensions#ale#enabled = 1
let g:ale_set_signs = 1
let g:ale_open_list = 1

" Linting frequency
let g:ale_lint_delay = 500

" Set which linters to enable
let g:ale_linters = {
  \ 'c': ['gcc'],
  \ 'java': ['javac'],
  \ 'rust': ['cargo'],
  \ 'haskell': ['hdevtools'],
  \ }
let g:ale_c_gcc_options = '-Wall -std=c99'
let g:ale_java_javac_options = '-Xlint:-overrides,-serial,-auxiliaryclass'
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:hdevtools_options = '--nostack'

" Enable line number highlighting
if has('nvim-0.3.2')
    let g:ale_sign_highlight_linenrs = 1
    hi ALEErrorSignLineNr cterm=bold ctermfg=red guifg=red
    hi ALEWarningSignLineNr cterm=bold ctermfg=blue guifg=blue
    hi ALEInfoSignLineNr cterm=bold ctermfg=green guifg=green
    hi ALEStyleErrorSignLineNr ctermfg=red guifg=red
    hi ALEStyleWarningSignLineNr ctermfg=yellow guifg=yellow
endif
set signcolumn=no

" This option is broken in some versions of Vim and it's not necessary
if !has('nvim')
    let g:ale_echo_cursor = 0
endif

" }}}

" QF setup
nmap <silent> gk <Plug>(qf_loc_previous)
nmap <silent> gj <Plug>(qf_loc_next)
nmap <silent> g= gjgk

" }}}

" Basic mappings {{{

let mapleader = '+'       " leader is plus

" Prevent accidental triggering of default meaning for leader
nnoremap <Leader> <Nop>

" Plain Vim has some weird glitches if mapping <Esc>
if has('nvim')
    " Disable search highlighting with <Esc> and clear bottom line
    nnoremap <Esc> :nohlsearch<CR>:<BS>
endif

" Disable search highlighting with <Leader><Space> (as a backup)
nnoremap <Leader><Space> :nohlsearch<CR>:<BS>

" Disable U to prevent mistakes
nnoremap U <Nop>

" Toggle folding with <Space>
nnoremap <Space> za

" For consistency with D and C
nnoremap Y y$

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

" Backslash to toggle buffers, split buffer
nnoremap \ <C-^>
nnoremap <silent> <C-w>\ :vsplit #<CR>

" Clear a line without removing the newline
nnoremap <silent> <Leader>d cc<Esc>

" Clear trailing whitespace in a file
nnoremap <silent> <Leader>C :keepp %s/\v\s+$//g<CR>

" Next and previous tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" For Coq overriding J
nnoremap <silent> <Leader>J J

" }}}
" Custom settings {{{

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

" Highlight column 121
set colorcolumn=121
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Ignored file types {{{
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
" }}}

" }}}
" Visual mode extensions {{{

" Make * and # work correctly on visual selections
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Make @<macro> work correctly on visual selections
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" }}}

" Indentation and folding {{{

set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4        " number of spaces to use for autoindent
set expandtab           " tabs are spaces
set autoindent          " copy indent from the previous line

set foldenable          " enable folding
set foldlevelstart=10   " only close deeply nested folds
set foldnestmax=10      " don't fold too deep

set foldmethod=indent   " indentation based folding

" }}}
" Better defaults {{{

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
set noshowmode          " hide "-- INSERT --"

set laststatus=2        " always show status line
set noerrorbells        " shhhh!
" set mouse=nich        " enable the mouse, but not visual selection
set mouse=ch            " only enable the mouse in help files

set autoread            " re-read files if not modified
set history=1000        " long undo history
set nrformats-=octal    " dont interpret leading 0 as octal

set ttimeoutlen=10      " for esacpe timeout in vim
set secure              " turn on additional security
set nomodeline          " turn off modelines for security
                        " (enabled later for vim files)

" }}}
" Autogroup configuration settings {{{
augroup vimrcgroup
    " Clear these settings if the file is sourced again
    autocmd!

    " File-specific configuration options
    autocmd FileType haskell setlocal
      \ shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType c,sh,zsh setlocal
      \ shiftwidth=2 tabstop=2 softtabstop=2 colorcolumn=81
    autocmd FileType python setlocal colorcolumn=81
    autocmd FileType javascript,typescript,typescriptreact setlocal
      \ shiftwidth=2 tabstop=2 softtabstop=2 colorcolumn=101
    autocmd FileType text,markdown setlocal
      \ shiftwidth=2 tabstop=2 softtabstop=2 colorcolumn=81 textwidth=80
    autocmd FileType boat setlocal
      \ shiftwidth=2 tabstop=2 softtabstop=2 commentstring=--\ %s
    autocmd BufEnter Makefile setlocal noexpandtab colorcolumn=81

    " ARM assembly
    autocmd FileType asm ALEDisableBuffer

    " Special settings for vim and help files
    autocmd FileType vim setlocal modeline colorcolumn=81

    " Special syntax highlighting
    autocmd BufRead,BufNewFile *.boat set filetype=boat
    autocmd FileType haskell syn match hsTypedef '\<pattern\>'

    " Treat .c and .h files as C, not C++
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c

    " Treat .html.hbs files as HTML
    autocmd BufRead,BufNewFile *.html.hbs set filetype=html

    autocmd BufRead,BufNewFile *.v nnoremap <silent> <buffer> J :CoqNext<CR>
    autocmd BufRead,BufNewFile *.v nnoremap <silent> <buffer> K :CoqUndo<CR>
    autocmd BufRead,BufNewFile *.v nnoremap <silent> <buffer> L :CoqToLine<CR>

    " Toggle ignorecase on insert for better <C-n> completion
    autocmd InsertEnter * set noignorecase
    autocmd InsertLeave * set ignorecase

    " Hide lint errors when inserting
    autocmd TextChangedI * ALEResetBuffer
augroup END
" }}}

" vim:foldmethod=marker:foldlevel=0:
