# Myconf

Personal dotfiles for macOS, Linux, and Windows.

## Quick Start

```bash
# macOS / Linux
git clone https://github.com/<user>/Myconf.git ~/Myconf && ~/Myconf/install.sh

# Windows (PowerShell as Admin)
git clone https://github.com/<user>/Myconf.git $HOME\Myconf; & $HOME\Myconf\install.ps1
```

## Usage

```bash
./install.sh              # Full install (packages + symlinks)
./install.sh link         # Symlinks only (skip package install)
./install.sh uninstall    # Remove all symlinks
```

## What's Included

| Tool | Platform | Path |
|------|----------|------|
| Vim | Shared | `shared/vim/` |
| Neovim | Shared | `shared/nvim/` |
| Git | Shared | `shared/git/` |
| Shell aliases/functions | Shared | `shared/shell/` |
| VSCode | Shared | `shared/vscode/` |
| Claude Code | Shared | `shared/ai/claude-code/` |
| OpenCode | Shared | `shared/ai/opencode/` |
| Zsh/Zprofile | macOS | `macos/shell/` |
| Karabiner | macOS | `macos/karabiner/` |
| iTerm2 | macOS | `macos/iterm2/` |
| Brewfile | macOS | `macos/Brewfile` |
| Zsh/Bash | Linux | `linux/shell/` |
| PowerShell | Windows | `windows/shell/` |
| Windows Terminal | Windows | `windows/windows-terminal/` |

## Machine-Specific Config

For settings that differ per machine (work email, local paths, etc.), use `.local` files:

- `~/.gitconfig.local` — Git overrides (included by `.gitconfig`)
- `~/.zshrc.local` — Shell overrides (sourced by `.zshrc`)

These files are gitignored and won't be tracked.
