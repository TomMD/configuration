local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'xavierchow/vim-swagger-preview'

Plug 'prabirshrestha/async.vim'

-- Nix syntax highlighting
Plug 'LnL7/vim-nix'

-- A framework for interacting with tests within NeoVim.
-- value unknown
Plug 'nvim-lua/plenary.nvim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'

-- An LSP client
Plug 'neovim/nvim-lspconfig'

Plug 'udalov/kotlin-vim'

-- An Rust LSP autoconfig system
Plug 'simrat39/rust-tools.nvim'

-- Debugging for rust-tools (?)
-- Plug 'nvim-lua/plenary.nvim'
-- Plug 'mfussenegger/nvim-dap'

--  Typescript checks
Plug 'Quramy/tsuquyomi'

--  :Gcommit, :Gdiff etc support
Plug 'tpope/vim-fugitive'

--  Status bar at bottom
Plug 'bling/vim-airline'

--  Vim plugin for displaying type annotations of TypeScript programs produced by RefScript
Plug 'panagosg7/vim-annotations'

--  use CTRL+A/X to create increasing sequence of numbers or letters via visual mode
Plug 'triglav/vim-visual-increment'

--  C-p to open files with fuzzy match
Plug 'kien/ctrlp.vim'

--  Aline things among other ops
Plug 'tommcdo/vim-lion'

--  Shell commands on visual blocks
Plug 'taku-o/vim-vis'

--  Show what has changed since commit on the left gutter.
Plug 'airblade/vim-gitgutter'

--  Syntax rules for Cryptol
Plug 'dmwit/vim-cryptol'

--  Syntax rules for fsharp
Plug 'fsharp/vim-fsharp'

--  Tag bar provides bar on RHS showing top level defs, etc.
--  i.e. nmap <F8> :TagbarToggle<CR>
Plug 'majutsushi/tagbar'

--  Color scheme making things darker
Plug 'joshdick/onedark.vim'

--  Asyc auto complete
-- Plug 'Shougo/deoplete.nvim'

-- Autocompletion framework
-- Value unknown
Plug("hrsh7th/nvim-cmp")
Plug( "hrsh7th/cmp-nvim-lsp")
    -- cmp Snippet completion
Plug("hrsh7th/cmp-vsnip")
    -- cmp Path completion
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-buffer")

--  typescript coloring
Plug 'ianks/vim-tsx'

--  Trouble for getting diagnistics
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

Plug 'williamboman/nvim-lsp-installer'
Plug 'mfussenegger/nvim-jdtls'
Plug 'georgewfraser/java-language-server'

-- Treesitter
Plug 'nvim-treesitter/nvim-treesitter'

-- Fuzzy find over files and contents
-- Plug 'nvim-lua/plenary.nvim'
-- Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'github/copilot.vim'

vim.call('plug#end')
vim.lsp.set_log_level("info")

-- nnoremap <C-n> :tabnext<Enter>
vim.keymap.set('n', '<C-n>', ':tabnext<Enter>')
-- nnoremap <C-m> :tabprev<Enter>
vim.keymap.set('n', '<C-b>', 'gT')

vim.opt.backspace = 'indent,eol,start'
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set('n', '<Leader><Leader>', ':noh<Enter>')
vim.opt.ruler = true
vim.opt_local.spelllang = 'en_us'
-- vim.opt.expandtab = true
-- vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.shiftround = true

-- Ignore build functions
-- vim.g.ctrlp_custom_ignore = [[node_modules|DS_Store|git|build*|dist*|.git]]
vim.g.ctrlp_user_command = 'git -C %s ls-files'

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', '<C-J>', '<C-W><C-J>')
vim.keymap.set('i', '<C-K>', '<C-W><C-K>')
vim.keymap.set('i', '<C-L>', '<C-W><C-L>')
vim.keymap.set('i', '<C-H>', '<C-W><C-H>')

-- Airline
vim.g.airline_powerline_fonts = true

-- Active split with C-{kjhl}
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- open tags in new tabs
vim.keymap.set('n', '<silent><C-[>', '<C-w><C-]><C-w>T')

-- Use the current window in the motion moves to something in view
vim.opt.switchbuf = 'useopen'
-- Use the current window or an existing tab in the motion moves to something in view
-- vim.opt.switchbuf = 'useopen,usetab'

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gc', vim.lsp.buf.incoming_calls)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

-- LSP Stuff
require("nvim-lsp-installer").setup {}
require('lspconfig')["hls"].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
       haskell = {
        formattingProvider = "fourmolu"
      }
  }
}
require('lspconfig').java_language_server.setup{
    on_attach = on_attach
}
require('lspconfig').kotlin_language_server.setup{
    on_attach = on_attach
}
require('lspconfig').gopls.setup{
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = require('lspconfig/util').root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
    on_attach = on_attach
}

local opts = {
    tools = {
        inlay_hints = {
            only_current_line = true,
        }
    },
    server = {
        on_attach = on_attach,
    }
}

local rt = require("rust-tools").setup(opts)
-- rt.setup({
--   server = {
--     on_attach = on_attach
--   },
-- })

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require("cmp")
cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },

  -- Installed sources
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "buffer" },
  },
})

-- Copilot keys
vim.keymap.set('v', '<space>c', 'copilot#Accept("\\<CR>")', { expr = true })
