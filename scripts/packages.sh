#!/usr/bin/env bash
# Package installation logic

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPTS_DIR/utils.sh"

# Install packages for macOS
install_macos_packages() {
    local dir="$1"

    # Install Homebrew if not present
    if ! command -v brew &>/dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        log_success "Homebrew already installed."
    fi

    # Install packages from Brewfile
    local brewfile="$dir/macos/Brewfile"
    if [[ -f "$brewfile" ]]; then
        log_info "Installing packages from Brewfile..."
        brew bundle --file="$brewfile"
    else
        log_warn "No Brewfile found at $brewfile"
    fi
}

# Install packages for Linux (Debian/Ubuntu)
install_linux_packages() {
    local dir="$1"

    local packages_file="$dir/linux/packages.txt"
    if [[ -f "$packages_file" ]]; then
        log_info "Installing packages from packages.txt..."
        sudo apt update
        xargs -a "$packages_file" sudo apt install -y
    else
        log_warn "No packages.txt found at $packages_file"
    fi
}

# Install VSCode extensions (cross-platform)
install_vscode_extensions() {
    local dir="$1"

    local ext_file="$dir/shared/vscode/extensions.txt"
    if [[ ! -f "$ext_file" ]]; then
        log_warn "No extensions.txt found at $ext_file"
        return 0
    fi

    if ! command -v code &>/dev/null; then
        log_warn "VSCode CLI (code) not found, skipping extension install."
        return 0
    fi

    log_info "Installing VSCode extensions..."
    while IFS= read -r ext; do
        # Skip empty lines and comments
        [[ -z "$ext" || "$ext" == \#* ]] && continue
        code --install-extension "$ext" --force
    done < "$ext_file"
}

# Main entry point
install_packages() {
    local dir="$1"
    local os="$2"

    case "$os" in
        macos)  install_macos_packages "$dir" ;;
        linux)  install_linux_packages "$dir" ;;
        *)      log_warn "Package install not supported for OS: $os" ;;
    esac

    install_vscode_extensions "$dir"
}
