local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

-- Core dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'prabirshrestha/async.vim'

-- LSP and language support
Plug 'neovim/nvim-lspconfig'
Plug 'mason-org/mason.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'georgewfraser/java-language-server'

-- Language-specific syntax
Plug 'LnL7/vim-nix'
Plug 'udalov/kotlin-vim'
Plug 'ianks/vim-tsx'
Plug 'dmwit/vim-cryptol'
Plug 'fsharp/vim-fsharp'
Plug 'Quramy/tsuquyomi'

-- Completion framework
-- Causing all sorts of issues on linux preventing typing every third character
-- Plug 'hrsh7th/nvim-cmp'
-- Plug 'hrsh7th/cmp-nvim-lsp'
-- Plug 'hrsh7th/cmp-vsnip'
-- Plug 'hrsh7th/cmp-path'
-- Plug 'hrsh7th/cmp-buffer'

-- Testing
Plug 'nvim-neotest/neotest'

-- UI and navigation
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
-- Plug 'bling/vim-airline'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

-- Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

-- Editing utilities
Plug 'triglav/vim-visual-increment'
Plug 'tommcdo/vim-lion'
Plug 'taku-o/vim-vis'
Plug 'panagosg7/vim-annotations'

-- Treesitter
Plug 'nvim-treesitter/nvim-treesitter'

-- Theme
Plug 'joshdick/onedark.vim'

-- AI assistance
Plug 'github/copilot.vim'
Plug 'coder/claudecode.nvim'

vim.call('plug#end')

-- General settings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.lsp.set_log_level("info")

-- Basic options
vim.opt.backspace = 'indent,eol,start'
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.ruler = true
vim.opt_local.spelllang = 'en_us'
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.switchbuf = 'useopen'

-- Plugin configurations
require("claudecode").setup({
  log_level = "info",
})

-- vim.g.airline_powerline_fonts = true
vim.g.ctrlp_user_command = 'git -C %s ls-files'

-- Keymaps
-- Tab navigation
vim.keymap.set('n', '<C-n>', ':tabnext<Enter>')
vim.keymap.set('n', '<C-b>', 'gT')

-- Clear search highlighting
vim.keymap.set('n', '<Leader><Leader><Leader>', ':noh<Enter>')

-- Movement and editing
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', '<C-J>', '<C-W><C-J>')
vim.keymap.set('i', '<C-K>', '<C-W><C-K>')
vim.keymap.set('i', '<C-L>', '<C-W><C-L>')
vim.keymap.set('i', '<C-H>', '<C-W><C-H>')
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit Terminal Mode" })

-- Window navigation
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Tag navigation
vim.keymap.set('n', '<silent><C-[>', '<C-w><C-]><C-w>T')

-- Claude Code keymaps
vim.keymap.set("n", "<leader>a", "<nop>", { desc = "AI/Claude Code", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

-- Conditional keymap for file tree plugins
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "neo-tree", "oil" },
  callback = function()
    vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { desc = "Add file" })
  end,
})

-- Copilot
vim.keymap.set('v', '<space>c', 'copilot#Accept("\\<CR>")', { expr = true })

-- LSP diagnostics keymaps
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- LSP keybindings via LspAttach autocmd (Neovim 0.11+ recommended pattern)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local bufnr = ev.buf
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    vim.keymap.set('n', '<space>ws', vim.lsp.buf.workspace_symbol, { noremap=true, silent=true, buffer=bufnr, desc = 'Workspace Symbols' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    -- nowait=true prevents conflict with built-in gcc (Toggle comment line)
    vim.keymap.set('n', 'gc', vim.lsp.buf.incoming_calls, { noremap=true, silent=true, buffer=bufnr, nowait=true })
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
  end,
})

-- LSP configurations
require("mason").setup {}

-- Haskell
vim.lsp.config['hls'] = {
    settings = {
       haskell = {
        formattingProvider = "fourmolu"
      }
  }
}
vim.lsp.enable('hls')

-- Java
vim.lsp.config['java_language_server'] = {}
vim.lsp.enable('java_language_server')

-- Kotlin
vim.lsp.config['kotlin_language_server'] = {}
vim.lsp.enable('kotlin_language_server')

-- Go
vim.lsp.config['gopls'] = {
    cmd = {"gopls"},
    filetypes = {"go", "gomod"},
    root_markers = {"go.work", "go.mod", ".git"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
}
vim.lsp.enable('gopls')

-- Rust
vim.lsp.config['rust-analyzer'] = {
  settings = {
    ['rust-analyzer'] = {
    },
  },
  cmd = { 'rust-analyzer' },
  filetypes = { 'rs', 'rust' },
  root_markers = { '.git', 'Cargo.toml' },
}
vim.lsp.enable('rust-analyzer')

-- Completion setup
-- vim.o.completeopt = "menuone,noinsert,noselect"
-- vim.opt.shortmess = vim.opt.shortmess + "c"
-- 
-- local cmp = require("cmp")
-- cmp.setup({
--   preselect = cmp.PreselectMode.None,
--   snippet = {
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   mapping = {
--     ["<C-p>"] = cmp.mapping.select_prev_item(),
--     ["<C-n>"] = cmp.mapping.select_next_item(),
--     ["<S-Tab>"] = cmp.mapping.select_prev_item(),
--     ["<Tab>"] = cmp.mapping.select_next_item(),
--     ["<C-d>"] = cmp.mapping.scroll_docs(-4),
--     ["<C-f>"] = cmp.mapping.scroll_docs(4),
--     ["<C-Space>"] = cmp.mapping.complete(),
--     ["<C-e>"] = cmp.mapping.close(),
--     ["<CR>"] = cmp.mapping.confirm({
--       behavior = cmp.ConfirmBehavior.Insert,
--       select = true,
--     }),
--   },
--   sources = {
--     { name = "nvim_lsp" },
--     { name = "vsnip" },
--     { name = "path" },
--     { name = "buffer" },
--   },
-- })


-- Copilot keys
vim.keymap.set('v', '<space>c', 'copilot#Accept("\\<CR>")', { expr = true })
