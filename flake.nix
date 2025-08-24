{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Support multiple systems
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
      # Helper function to generate configs for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # Read username from environment, fallback to "tommd"
      username = let envUser = builtins.getEnv "USER"; in
        if envUser != "" then envUser else "tommd";
      
      # Create home manager configuration for a given system (uses env username)
      mkHomeConfiguration = system: 
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          
          # Determine home directory based on system and username
          homeDirectory = if builtins.match ".*-darwin" system != null 
            then "/Users/${username}"
            else "/home/${username}";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home.username = username; 
              home.homeDirectory = homeDirectory;
            home.stateVersion = "23.05";

            # Install packages from your current nix profile
            home.packages = with pkgs; [
              claude-code
              coreutils
              diff-so-fancy
              gh
              pgcli
              postgresql
              ripgrep
              tmux
              vault
              # Additional packages for Neovim plugins, incl Rust, Go, Haskell
              nodejs
              python3
              cargo
              rustc
              go
              gopls
              haskell-language-server
              home-manager
              
              # Language servers for LSP
              lua-language-server
              nil # Nix language server
              typescript-language-server
              kotlin-language-server
              nixpkgs-fmt # Nix formatter
            ];

            # Enable Home Manager to manage itself
            programs.home-manager.enable = true;

            # Environment variables
            home.sessionVariables = {
              LANG = "en_US.UTF-8";
              EDITOR = "nvim";
            };

            # Zsh configuration matching your zshrc
            programs.zsh = {
              enable = true;
              enableCompletion = true;
              autosuggestion.enable = true;
              syntaxHighlighting.enable = true;
              
              history = {
                size = 1000;
                save = 1000;
                ignoreDups = true;
                ignoreAllDups = true;
                ignoreSpace = true;
                path = "$HOME/.histfile";
              };
              
              initContent = ''
                # Vi mode keybindings
                bindkey -v
                bindkey -M viins 'jk' vi-cmd-mode
                bindkey '^R' history-incremental-search-backward
                
                # Source private config if it exists
                if [ -e "$HOME/.zshrc_private_stuff" ]; then
                  source "$HOME/.zshrc_private_stuff"
                fi
                alias gb="git branch | grep '*'"

                alias rgg="rg --iglob '!*test*' --iglob '!*mock*' --iglob '!*fake*'"
              '';
              
              shellAliases = {
                ls = if pkgs.stdenv.isDarwin then "ls -G" else "ls --color -G";
                o = if pkgs.stdenv.isDarwin then "open" else "xdg-open";
              };
            };

            # Git configuration with diff-so-fancy
            programs.git = {
              enable = true;
              extraConfig = {
                core.pager = "diff-so-fancy | less --tabs=4 -RFX";
                color.ui = true;
              };
            };

            # Tmux configuration
            programs.tmux = {
              enable = true;
              terminal = "screen-256color";
              keyMode = "vi";
              extraConfig = ''
                set -g mouse on
                set -g history-limit 10000
                
                # Split panes using | and -
                bind | split-window -h
                bind - split-window -v
                unbind '"'
                unbind %
                
                # Switch panes using Alt-arrow without prefix
                bind -n M-Left select-pane -L
                bind -n M-Right select-pane -R
                bind -n M-Up select-pane -U
                bind -n M-Down select-pane -D
              '';
            };

            # Complete Neovim configuration matching your init.lua
            programs.neovim = {
              enable = true;
              defaultEditor = true;
              viAlias = true;
              vimAlias = true;
              
              plugins = with pkgs.vimPlugins; [
                # Core dependencies
                plenary-nvim
                FixCursorHold-nvim
                async-vim
                
                # LSP and language support
                nvim-lspconfig
                rust-tools-nvim
                nvim-jdtls
                
                # Language-specific syntax
                vim-nix
                kotlin-vim
                vim-tsx
                zarchive-vim-fsharp
                
                # Completion framework
                nvim-cmp
                cmp-nvim-lsp
                cmp-vsnip
                cmp-path
                cmp-buffer
                
                # Testing
                neotest
                
                # UI and navigation
                ctrlp-vim
                tagbar
                vim-airline
                nvim-web-devicons
                trouble-nvim
                
                # Git integration
                vim-fugitive
                vim-gitgutter
                
                # Editing utilities
                vim-visual-increment
                vim-lion
                
                # Treesitter
                (nvim-treesitter.withPlugins (p: with p; [
                  tree-sitter-c
                  tree-sitter-lua
                  tree-sitter-vim
                  tree-sitter-vimdoc
                  tree-sitter-query
                  tree-sitter-python
                  tree-sitter-javascript
                  tree-sitter-typescript
                  tree-sitter-tsx
                  tree-sitter-rust
                  tree-sitter-go
                  tree-sitter-haskell
                  tree-sitter-nix
                  tree-sitter-kotlin
                  tree-sitter-java
                ]))
                
                # Theme
                onedark-vim
                
                # AI assistance
                copilot-vim
                
                # Snippets
                vim-vsnip
              ];

              extraLuaConfig = ''
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

                vim.g.airline_powerline_fonts = true
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

                -- Copilot
                vim.keymap.set('v', '<space>c', 'copilot#Accept("\\<CR>")', { expr = true })

                -- LSP diagnostics keymaps
                local opts = { noremap=true, silent=true }
                vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

                -- LSP on_attach function
                local on_attach = function(client, bufnr)
                  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                  local bufopts = { noremap=true, silent=true, buffer=bufnr }
                  vim.keymap.set('n', '<space>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { desc = 'Workspace Symbols' })
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

                -- LSP configurations
                local lspconfig = require('lspconfig')

                -- Haskell
                require('lspconfig').hls.setup{
                    on_attach = on_attach,
                    flags = lsp_flags,
                    settings = {
                       haskell = {
                        formattingProvider = "fourmolu"
                      }
                  }
                }

                -- Kotlin
                require('lspconfig').kotlin_language_server.setup{
                    on_attach = on_attach
                }

                -- Go
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

                -- Rust
                local rt = require("rust-tools").setup({
                    tools = {
                        inlay_hints = {
                            only_current_line = true,
                        }
                    },
                    server = {
                        on_attach = on_attach,
                    }
                })

                -- Nix
                lspconfig.nil_ls.setup{
                    on_attach = on_attach,
                    settings = {
                      ['nil'] = {
                        formatting = {
                          command = { "nixpkgs-fmt" },
                        },
                      },
                    },
                }

                -- Lua (for Neovim config)
                lspconfig.lua_ls.setup{
                    on_attach = on_attach,
                    settings = {
                      Lua = {
                        runtime = {
                          version = 'LuaJIT',
                        },
                        diagnostics = {
                          globals = {'vim'},
                        },
                        workspace = {
                          library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = {
                          enable = false,
                        },
                      },
                    },
                }

                -- TypeScript/JavaScript
                lspconfig.tsserver.setup{
                    on_attach = on_attach,
                }

                -- Completion setup
                vim.o.completeopt = "menuone,noinsert,noselect"
                vim.opt.shortmess = vim.opt.shortmess + "c"

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
                  sources = {
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "path" },
                    { name = "buffer" },
                  },
                })
              '';
            };

            # Ripgrep configuration
            programs.ripgrep = {
              enable = true;
              arguments = [
                "--max-columns=150"
                "--max-columns-preview"
                "--smart-case"
                "--hidden"
                "--glob=!.git/*"
              ];
            };

            # GitHub CLI configuration
            programs.gh = {
              enable = true;
              settings = {
                editor = "nvim";
                git_protocol = "ssh";
              };
            };
          }
        ];
        };
    in {
      homeConfigurations = {
        # Auto-detecting default configuration (reads $USER and detects current system)
        default = mkHomeConfiguration builtins.currentSystem;
        
        # System-specific configurations
        x86_64-linux = mkHomeConfiguration "x86_64-linux";
        aarch64-linux = mkHomeConfiguration "aarch64-linux";
        x86_64-darwin = mkHomeConfiguration "x86_64-darwin";
        aarch64-darwin = mkHomeConfiguration "aarch64-darwin";
      };
    };
}
