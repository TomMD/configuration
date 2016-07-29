set nocompatible

" Setup bundles
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle
Plugin 'VundleVim/Vundle.vim'

" External packages
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
Plugin 'panagosg7/vim-annotations'
Plugin 'dag/vim2hs'
Plugin 'triglav/vim-visual-increment'
" Plugin 'kien/ctrlp.vim'
Plugin 'ndmitchell/ghcid'
Plugin 'Shougo/vimproc.vim'
Plugin 'Twinside/vim-syntax-haskell-cabal'
" Plugin 'godlygeek/tabular'
Plugin 'tommcdo/vim-lion'
Plugin 'taku-o/vim-vis.git'
Plugin 'tommcdo/vim-exchange'
Plugin 'airblade/vim-gitgutter'
Plugin 'elliottt/vim-haskell'
Plugin 'bitc/vim-hdevtools'
" Plugin 'Rykka/riv.vim'
Plugin 'tpope/vim-abolish'
Plugin 'dmwit/vim-cryptol'
Plugin 'fsharp/vim-fsharp'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
" surround
" easymotion

call vundle#end()
filetype plugin indent on
syntax on

set ignorecase smartcase

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"

"" Allow backspacing over everything
set backspace=indent,eol,start
"
"" Incremental searching
set incsearch
set hlsearch
set ignorecase
set smartcase

" Allow \ \ to kill the search highlighting.
map <Leader><Leader> :noh<Enter>

" Always show cursor position
set ruler

" Fold by manually defined folds
" set foldenable
" Get rid of folding (function hiding)
set nofoldenable

" Syntax
if &t_Co > 2 || has("gui_running")
    syntax enable
    set hlsearch
endif

" Spell checking
if has("spell")
    setlocal spelllang=en_us
    setlocal nospell
endif

" Highlight lines longer than 80 chars
" let w:m80=matchadd('ErrorMsg', '\%>80v.\+', -1)
set textwidth=80

" Highlight trailing space, and tab characters
set list lcs=tab:>-,trail:.

" Tabs are spaces
set expandtab
set shiftwidth=4
set smarttab
set shiftround
set nojoinspaces

highlight ghcmodType ctermbg=yellow
let g:ghcmod_type_highlight = 'ghcmodType'
highlight ghcmodType ctermbg=yellow
let g:hlint_args = '-i "Redundant bracket"'

" Automatic section commenting via "--s"
let s:width = 80

function! HaskellModuleSection(...)
    let name = 0 < a:0 ? a:1 : inputdialog("Section name: ")

    return  repeat('-', s:width) . "\n"
    \       . "--  " . name . "\n"
    \       . "\n"
endfunction

nmap <silent> --s "=HaskellModuleSection()<CR>gp

"" Tab navigation
nmap <C-n> gt
nmap <C-m> gT

"" Disable the help key
nmap <F1> <Esc>
imap <F1> <Esc>

"" Print options
set printoptions=paper:letter

"" Completion options
set wildmode=full
set wildmenu
set wildignore=*.o,*.hi,*.swp,*.bc

" Colors!
set bg=dark

"" Disable the arrow keys when in edit mode
inoremap <Up> <NOP>
inoremap <Right> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap jk <Esc>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Airline config
set laststatus=2
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts=0

" F2 toggles paste mode
set pastetoggle=<F2>

" neocomplcache for neco-ghc
let g:acp_enableAtStartup = 0
" Use neocomplcache
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable omni completion.
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" vim2hs unicode symbols
" let g:haskell_conceal_wide = 1
" alt: no concealing at all:
let g:haskell_conceal = 0
let g:haskell_conceal_enumerations = 0


"
"##############################################################################
" Easier split navigation
"##############################################################################
"
" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

vnoremap <silent> s :'<,'>sort /import\(\s\+qualified\)\?\s\+/<CR>
nnoremap Q <nop>

nmap <silent> <c-q> :SyntasticCheck liquid<CR>

set encoding=utf8
autocmd FileType haskell set cpoptions+=M

let g:haskell_multiline_strings = 1

"
" HDevTools support
"

au FileType haskell noremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell noremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell noremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>
let g:syntastic_haskell_hdevtools_args = '-g-Wwarn -g-w -g-Wall'

" Underline the current line with dashes in normal mode
nnoremap <F5> yyp<c-v>$r-

" Underline the current line with dashes in insert mode
inoremap <F5> <Esc>yyp<c-v>$r-A

" No RIV folding
let g:riv_fold_level = 0
let g:riv_fold_auto_update = 0
au BufRead,BufNewFile *.md setlocal textwidth=80
