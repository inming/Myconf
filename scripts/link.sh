#!/usr/bin/env bash
# Symlink mapping for all configurations
# Add new tool configs here following the safe_link pattern


# Link shared (cross-platform) configs
link_shared() {
    local dir="$1"

    log_info "Linking shared configs..."

    # Vim
    safe_link "$dir/shared/vim/.vimrc" "$HOME/.vimrc"

    # Neovim
    safe_link "$dir/shared/nvim" "$HOME/.config/nvim"

    # Git
    safe_link "$dir/shared/git/.gitconfig" "$HOME/.gitconfig"
    safe_link "$dir/shared/git/.gitignore_global" "$HOME/.gitignore_global"

    # Shell (shared aliases and functions)
    # These are sourced by platform-specific .zshrc/.bashrc, no direct symlink needed

    # VSCode - target path depends on OS
    local vscode_dir
    case "$(detect_os)" in
        macos)  vscode_dir="$HOME/Library/Application Support/Code/User" ;;
        linux)  vscode_dir="$HOME/.config/Code/User" ;;
        windows) vscode_dir="$APPDATA/Code/User" ;;
    esac
    if [[ -n "$vscode_dir" ]]; then
        mkdir -p "$vscode_dir"
        safe_link "$dir/shared/vscode/settings.json" "$vscode_dir/settings.json"
        safe_link "$dir/shared/vscode/keybindings.json" "$vscode_dir/keybindings.json"
    fi

    # AI tools
    # Claude Code
    safe_link "$dir/shared/ai/claude-code/settings.json" "$HOME/.claude/settings.json"
    # OpenCode
    safe_link "$dir/shared/ai/opencode/config.json" "$HOME/.config/opencode/config.json"
}

# Link macOS-specific configs
link_macos() {
    local dir="$1"

    log_info "Linking macOS configs..."

    # Shell
    safe_link "$dir/macos/shell/.zshrc" "$HOME/.zshrc"

    # Karabiner
    safe_link "$dir/macos/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

    # iTerm2
    safe_link "$dir/macos/iterm2/com.googlecode.iterm2.plist" \
        "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
}

# Link Linux-specific configs
link_linux() {
    local dir="$1"

    log_info "Linking Linux configs..."

    # Shell
    safe_link "$dir/linux/shell/.zshrc" "$HOME/.zshrc"
    safe_link "$dir/linux/shell/.bashrc" "$HOME/.bashrc"
}

# Link Windows-specific configs (called from install.ps1 via WSL or Git Bash)
link_windows() {
    local dir="$1"

    log_info "Linking Windows configs..."

    # Windows Terminal
    local wt_dir="$LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
    if [[ -d "$wt_dir" ]]; then
        safe_link "$dir/windows/windows-terminal/settings.json" "$wt_dir/settings.json"
    fi
}

# Link platform-specific configs based on detected OS
link_platform() {
    local dir="$1"
    local os="$2"

    case "$os" in
        macos)   link_macos "$dir" ;;
        linux)   link_linux "$dir" ;;
        windows) link_windows "$dir" ;;
    esac
}

# Unlink all configs (for cleanup)
unlink_all() {
    local dir="$1"

    log_info "Unlinking all configs..."

    # Shared
    safe_unlink "$dir/shared/vim/.vimrc" "$HOME/.vimrc"
    safe_unlink "$dir/shared/nvim" "$HOME/.config/nvim"
    safe_unlink "$dir/shared/git/.gitconfig" "$HOME/.gitconfig"
    safe_unlink "$dir/shared/git/.gitignore_global" "$HOME/.gitignore_global"
    safe_unlink "$dir/shared/ai/claude-code/settings.json" "$HOME/.claude/settings.json"
    safe_unlink "$dir/shared/ai/opencode/config.json" "$HOME/.config/opencode/config.json"

    # Platform
    local os
    os="$(detect_os)"
    case "$os" in
        macos)
            safe_unlink "$dir/macos/shell/.zshrc" "$HOME/.zshrc"
            safe_unlink "$dir/macos/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
            safe_unlink "$dir/macos/iterm2/com.googlecode.iterm2.plist" \
                "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
            ;;
        linux)
            safe_unlink "$dir/linux/shell/.zshrc" "$HOME/.zshrc"
            safe_unlink "$dir/linux/shell/.bashrc" "$HOME/.bashrc"
            ;;
    esac

    log_success "All configs unlinked."
}
