call plug#begin()

" Intel engine, leveraging LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

" Indentation and highlighting
Plug 'neovimhaskell/haskell-vim'

"
Plug 'dense-analysis/ale'

" Use `:Hindent`
" Plug 'alx741/vim-hindent'
Plug 'mpickering/hlint-refactor-vim'

" Auto completions general support
" Plug 'Shougo/deoplete.nvim'
" Auto completions for Haskell (leveraging deoplete)
" Plug 'eagletmt/neco-ghc'

Plug 'owickstrom/neovim-ghci'
Plug 'neomake/neomake'

" :Gcommit, :Gdiff etc
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
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts=0

" F2 toggles paste mode
set pastetoggle=<F2>

" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
" Enable omni completion from necoghc
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
let g:necoghc_enable_detailed_browse = 1

let g:deoplete#enable_at_startup = 1


" Use ctrl-[hjkl] to select the active split.
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-l> <C-w>l

" use '@s' to format haskell import statements
vnoremap <silent> s :'<,'>sort /import\(\s\+qualified\)\?\s\+/<CR>
nnoremap Q <nop>

" Liquid haskell type checking
" nmap <silent> <c-t> :SyntasticCheck liquid<CR>
" let g:syntastic_haskell_checkers = []
" let g:vim_annotations_offset = '/.liquid/'

" Make '%' and company handle nested parens
autocmd FileType haskell set cpoptions+=M

" Transform 'import A.B' into 'import A.B (B) ; import qualified A.B as B'
let @i="0elcw           \<ESC>$byawA (\<ESC>pA)\<ESC>yypellRqualified\<ESC>$xbXias \<ESC>"

" Open tags in new tabs (via C-[)
nnoremap <silent><C-[> <C-w><C-]><C-w>T

" Background keeps getting messed up by.. what?
set background=light

" GHCi module options
augroup ghciMaps
  au!
  " Maps for ghci. Restrict to Haskell buffers so the bindings don't collide.

  " Background process and window management
  au FileType haskell nnoremap <silent> <leader>gs :GhciStart<CR>
  au FileType haskell nnoremap <silent> <leader>gk :GhciKill<CR>

  " Restarting GHCi might be required if you add new dependencies
  au FileType haskell nnoremap <silent> <leader>gr :GhciRestart<CR>

  " Open GHCi split horizontally
  au FileType haskell nnoremap <silent> <leader>go :GhciOpen<CR>
  " Open GHCi split vertically
  au FileType haskell nnoremap <silent> <leader>gov :GhciOpen<CR><C-W>H
  au FileType haskell nnoremap <silent> <leader>gh :GhciHide<CR>

  " Get info
  au FileType haskell nnoremap <silent> <leader>gi :GhciInfo<CR>

  " Automatically reload on save
  " au BufWritePost *.hs GhciReload
  " Manually save and reload
  au FileType haskell nnoremap <silent> <leader>wr :w \| :GhciReload<CR>

  " Load individual modules
  au FileType haskell nnoremap <silent> <leader>gl :GhciLoadCurrentModule<CR>
  au FileType haskell nnoremap <silent> <leader>gf :GhciLoadCurrentFile<CR>
augroup END

" Prevent GHCi from starting automatically
let g:ghci_start_immediately = 0

" Customize how to run GHCi
let g:ghci_command = 'cabal new-repl'
let g:ghci_command_line_options = '-fobject-code'
" Bug in ghci wrt how it thinks ghci is started/not loaded
let g:ghci_started = 0

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Use Esc to exit terminal mode.
tnoremap <Esc> <C-\><C-n>

vnoremap <leader>bb ! brittany<CR>

" Set LSP startup
au User lsp_setup call lsp#register_server({
    \ 'name': 'ghcide',
    \ 'cmd': {server_info->[expand('~/.cabal/bin/ghcide'), '--lsp']},
    \ 'whitelist': ['haskell'],
    \ })
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
map <Leader>lh :LspHover<CR>
map <Leader>lg :LspDefinition<CR>
map <Leader>lr :LspRename<CR>
map <Leader>lF :LspDocumentFormat<CR>
map <Leader>lf :LspDocumentRangeFormat<CR>
map <Leader>ls :LspDocumentSymbol<CR>
map <Leader>ls :LspDocumentSymbol<CR>
map <Leader>li :LspImplementation<CR>
map <Leader>ln :LspNextError<CR>
map <Leader>lpi :LspPeekImplementation<CR>
map <Leader>lpt :LspPeekTypeDefinition<CR>
map <Leader>lpd :LspPeekDeclaration<CR>
map <Leader>lpf :LspPeekDefinition<CR>
" Like "lsp who uses this"
map <Leader>lw :LspReferences<CR>

nmap <leader>lx  <Plug>(coc-fix-current)
