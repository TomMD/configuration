# Home Manager Configuration

This flake provides a cross-platform Home Manager configuration that automatically detects your username and system architecture.

## Quick Start

### If Home Manager is not installed yet:
```bash
nix run home-manager/master -- switch --flake .#default --impure
```

### If Home Manager is already installed:
```bash
home-manager switch --flake .#default --impure
```

## Why `--impure`?

The `--impure` flag is required because this configuration reads environment variables (`$USER` and detects the current system) to automatically configure itself for your machine.

## What it manages

- **Shell (Zsh)**: Vi mode, history, aliases, autocompletion
- **Neovim**: Complete LSP setup with plugins for Rust, Go, Haskell, etc.
- **Git**: Configured with diff-so-fancy pager
- **Tmux**: Vi mode with custom keybindings
- **CLI tools**: ripgrep, gh, claude-code, and more
- **Development**: Language servers, formatters, and build tools

## System Support

The configuration automatically adapts to:
- **macOS** (both Intel and ARM): Uses `/Users/$USER` home directory
- **Linux** (x86_64 and ARM): Uses `/home/$USER` home directory

## Available Configurations

- `default` - Auto-detects current system and user (recommended)
- `x86_64-linux` - Explicit Linux x86_64
- `aarch64-linux` - Explicit Linux ARM64  
- `x86_64-darwin` - Explicit macOS Intel
- `aarch64-darwin` - Explicit macOS ARM64

## Examples

**First time setup on any machine:**
```bash
nix run home-manager/master -- switch --flake .#default --impure
```

**Regular updates:**
```bash
home-manager switch --flake .#default --impure
```

**Force specific system (if auto-detection fails):**
```bash
home-manager switch --flake .#x86_64-linux --impure  # Linux
home-manager switch --flake .#aarch64-darwin --impure  # macOS ARM
```

## Customization

The configuration includes:
- Custom aliases (`gb` for git branch, `rgg` for filtered ripgrep)
- Vi mode keybindings in shell and tmux
- Complete Neovim setup with LSP for multiple languages
- Zsh with autosuggestions and syntax highlighting

Private configuration can be added to `~/.zshrc_private_stuff` which will be sourced automatically.