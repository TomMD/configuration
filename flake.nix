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
              rust-analyzer # Rust LSP server
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

	      # blockchain things
	      solana-cli
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
                
                # Accept autosuggestion with Ctrl+Space
                bindkey '^ ' autosuggest-accept
                
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
                vi = "nvim";
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
              prefix = "C-j";
              terminal = "screen-256color";
              keyMode = "vi";
              extraConfig = ''
                set-option -g default-shell /bin/zsh
                unbind-key C-b
                bind-key C-j send-prefix
                
                bind-key -n C-M-u resize-pane -U 1
                bind-key -n C-M-d resize-pane -D 1
                bind-key -n C-M-l resize-pane -L 1
                bind-key -n C-M-r resize-pane -R 1
                bind '"' split-window -c "#{pane_current_path}"
                bind '%' split-window -h -c "#{pane_current_path}"
                bind 'k' respawn-pane -k
                set-window-option -g mode-keys vi
                set -g visual-bell on
                
                unbind P
                bind P paste-buffer
                bind-key -T copy-mode-vi v send-keys -X begin-selection
                bind-key -T copy-mode-vi y send-keys -X copy-selection
                bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
                
                # Options suggested by nvim
                set -sg escape-time 0
                set -g default-terminal "screen-256color"
              '';
            };

            # Complete Neovim configuration matching your init.lua
            programs.neovim = {
              enable = true;
              defaultEditor = true;
              viAlias = true;
              vimAlias = true;
              withNodeJs = true;
              withPython3 = true;
              
              # Read the local init.lua file and use it as extraLuaConfig
              extraLuaConfig = builtins.readFile ./init.lua;
              
              extraPackages = with pkgs; [
                # LSP servers and tools (already included above but explicit here)
                haskell-language-server
                kotlin-language-server
                gopls
                rust-analyzer
                lua-language-server
                nil
                typescript-language-server
                nixpkgs-fmt
              ];
              
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
