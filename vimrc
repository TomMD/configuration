set nocompatible

" Setup bundles
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle
Bundle 'gmarik/vundle'

" External packages
Bundle 'tpope/vim-markdown'
Bundle 'IndentAnything'
Bundle 'OOP-javascript-indentation'
Bundle 'aaronbieber/quicktask'
Bundle 'Lokaltog/vim-powerline'
Bundle "vim2hs"
Bundle "neocomplcache"
Bundle "neco-ghc"

" Enable filetype detection
filetype plugin indent on

set ignorecase smartcase

" Allow backspacing over everything
set backspace=indent,eol,start

" Incremental searching
set incsearch

" Allow \ \ to kill the search highlighting.
map <Leader><Leader> :noh<Enter>

" Always show cursor position
set ruler

" Fold by manually defined folds
set foldenable

" Syntax
if &t_Co > 2 || has("gui_running")
    syntax enable
    set hlsearch
endif

" Spell checking
if has("spell")
    setlocal spell spelllang=en_us
    set nospell
endif

" Highlight lines longer than 80 chars
let w:m80=matchadd('ErrorMsg', '\%>80v.\+', -1)
set textwidth=80

" Highlight trailing space, and tab characters
set list lcs=tab:>-,trail:.

" Tabs are spaces
set expandtab
set shiftwidth=4
set smarttab
set shiftround
set nojoinspaces

" Automatic section commenting via "--s"
let s:width = 80

function! HaskellModuleSection(...)
    let name = 0 < a:0 ? a:1 : inputdialog("Section name: ")

    return  repeat('-', s:width) . "\n"
    \       . "--  " . name . "\n"
    \       . "\n"

endfunction

nmap <silent> --s "=HaskellModuleSection()<CR>gp

" Tab navigation
nmap <C-n> gt
nmap <C-p> gT

" Disable the help key
nmap <F1> <Esc>
imap <F1> <Esc>

" Print options
set printoptions=paper:letter

" Completion options
set wildmode=full
set wildmenu
set wildignore=*.o,*.hi,*.swp,*.bc

" Colors!
colors default
set bg=dark

" Disable the arrow keys when in edit mode
inoremap <Up> <NOP>
inoremap <Right> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>

" Set F2 as the binding to toggle the paste mode
set pastetoggle=<F2>

" Powerline config
set laststatus=2
let g:Powerline_symbols = 'fancy'

" F2 toggles paste mode
set pastetoggle=<F2>

" necomplcache for neco-ghc
let g:neocomplcache_enable_at_startup = 1

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string() 

" Recommended key-mappings.
" " <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>" 
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>" 
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup() 

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags 
