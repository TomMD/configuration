" see init.lua. Do not use
call plug#begin()

Plug 'prabirshrestha/async.vim'

" An LSP client
Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'

"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }

" Typescript checks
Plug 'Quramy/tsuquyomi'

" :Gcommit, :Gdiff etc support
Plug 'tpope/vim-fugitive'

" Status bar at bottom
Plug 'bling/vim-airline'

" Vim plugin for displaying type annotations of TypeScript programs produced by RefScript
Plug 'panagosg7/vim-annotations'

" use CTRL+A/X to create increasing sequence of numbers or letters via visual mode
Plug 'triglav/vim-visual-increment'

" C-p to open files with fuzzy match
Plug 'kien/ctrlp.vim'

" Aline things among other ops
Plug 'tommcdo/vim-lion'

" Shell commands on visual blocks
Plug 'taku-o/vim-vis'

" Show what has changed since commit on the left gutter.
Plug 'airblade/vim-gitgutter'

" Syntax rules for Cryptol
Plug 'dmwit/vim-cryptol'

" Syntax rules for fsharp
Plug 'fsharp/vim-fsharp'

" Tag bar provides bar on RHS showing top level defs, etc.
" i.e. nmap <F8> :TagbarToggle<CR>
Plug 'majutsushi/tagbar'

" Color scheme making things darker
Plug 'joshdick/onedark.vim'

" Asyc auto complete
Plug 'Shougo/deoplete.nvim'

" typescript coloring
Plug 'ianks/vim-tsx'

" LSP support for typescript (must come after vim-lsp)
Plug 'ryanolsonx/vim-lsp-typescript'

call plug#end()

filetype plugin indent on
syntax on

"" Disable the mouse integration in most cases
set mouse=h

"" Allow backspacing over everything
set backspace=indent,eol,start

"" Incremental searching
set incsearch
set hlsearch
set ignorecase
set smartcase

" Allow \ \ to kill the search highlighting.
map <Leader><Leader> :noh<Enter>

" Always show cursor position
set ruler

" Spell checking
if has("spell")
    setlocal spelllang=en_us
    setlocal nospell
endif

" Highlight lines longer than 100 chars
let w:m100=matchadd('ErrorMsg', '\%>100v.\+', -1)
set textwidth=100

" Highlight trailing space, and tab characters
set list lcs=tab:>-,trail:.

" Tabs are spaces
set expandtab
set shiftwidth=4
set smarttab
set shiftround
set nojoinspaces

" highlight ghcmodType ctermbg=yellow
let g:ghcmod_type_highlight = 'ghcmodType'
" highlight ghcmodType ctermbg=yellow
let g:hlint_args = '-i "Redundant bracket"'

" " Automatic section commenting via "--s"
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
nmap <C-m> gT

" Disable the help key
nmap <F1> <Esc>
imap <F1> <Esc>

" Print options
set printoptions=paper:letter

" Completion options
set wildmode=full
set wildmenu
set wildignore=*.o,*.hi,*.swp,*.bc

" Disable the arrow keys when in edit mode
inoremap <Up> <NOP>
inoremap <Right> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap jk <Esc>
inoremap <C-u>bc <C-V>u2235
" Ctrl-u+b+c ~ unicode 'because'

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Airline config
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" Powerline fonts look good if you have them
let g:airline_powerline_fonts=1

" F2 toggles paste mode
set pastetoggle=<F2>

" Use async auto complete automatically
let g:deoplete#enable_at_startup = 1

" Use ctrl-[hjkl] to select the active split.
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-l> <C-w>l

" use '@s' to format haskell import statements
vnoremap <silent>@s :'<,'>sort /import\(\s\+qualified\)\?\s\+/<CR>
nnoremap Q <nop>

" Make '%' and company handle nested parens
autocmd FileType haskell set cpoptions+=M

" Transform 'import A.B' into 'import A.B (B) ; import qualified A.B as B'
let @i="0elcw           \<ESC>$byawA (\<ESC>pA)\<ESC>yypellRqualified\<ESC>$xbXias \<ESC>"

" Open tags in new tabs (via C-[)
nnoremap <silent><C-[> <C-w><C-]><C-w>T

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Use Esc to exit terminal mode.
tnoremap <Esc> <C-\><C-n>

" For  LanguageClient-neovim
" let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
" let g:LanguageClient_loggingLevel=  'warn'
" let g:LanguageClient_rootMarkers = ['cabal.project']
" let g:LanguageClient_waitOutputTimeout = 3600
" set rtp+=~/.config/nvim/plugged/LanguageClient-neovim
" let g:LanguageClient_serverCommands = {
"      \ 'haskell': ['haskell-language-server-wrapper', '--lsp'],
"      \ }
" let g:LanguageClient_settingsPath = expand("~/.config/nvim/settings.json")
" 
" nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" nnoremap <Leader>lh :call LanguageClient#textDocument_hover()<CR>
" nnoremap <Leader>lg :call LanguageClient#textDocument_definition()<CR>
" nnoremap <Leader>lr  :call LanguageClient#textDocument_rename()<CR>
" nnoremap <Leader>lt <C-w>:call LanguageClient#textDocument_definition()<CR><C-w>T
" nnoremap <Leader>la :call LanguageClient#textDocument_codeAction()<CR><C-w>T
" nnoremap <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
" For vim-lsp:
if executable('haskell-language-server-wrapper')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'haskell-language-server',
        \ 'cmd': {server_info->['haskell-language-server-8.10.1', '--lsp']},
        \ 'allowlist': ['haskell'],
        \ 'config' : { 'languageServerHaskell' : { 'formattingProvider' : 'fourmolu' , 'formattingOptions' : { 'tabSize' : 4 } } },
        \ 'workspace_config' : { 'languageServerHaskell' : { 'formattingProvider' : 'fourmolu' , 'formattingOptions' : { 'tabSize' : 4, 'respectful' : 'false' }}},
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gD <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> F <plug>(lsp-document-format)
    nmap <buffer> U <plug>(lsp-code-action)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction
let g:lsp_log_verbose = 1
let g:lsp_log_file = '/tmp/vim-lsp.log'
let g:lsp_settings = { 'haskell' : { 'formattingProvider' : 'fourmolu' , 'formattingOptions' : { 'tabSize' : 4 }} }

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

colorscheme onedark
nnoremap <C-n> :tabnext<Enter>
nnoremap <C-m> :tabprev<Enter>
