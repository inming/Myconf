#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES_DIR/scripts/utils.sh"
source "$DOTFILES_DIR/scripts/link.sh"
source "$DOTFILES_DIR/scripts/packages.sh"

OS="$(detect_os)"

echo ""
echo "========================================="
echo "  Myconf Dotfiles Installer"
echo "  OS: $OS"
echo "========================================="
echo ""

# Parse arguments
ACTION="${1:-install}"

case "$ACTION" in
    install)
        log_info "Starting installation..."

        # Step 1: Install packages
        install_packages "$DOTFILES_DIR" "$OS"

        # Step 2: Link shared configs
        link_shared "$DOTFILES_DIR"

        # Step 3: Link platform-specific configs
        link_platform "$DOTFILES_DIR" "$OS"

        # Step 4: Platform-specific post-install
        if [[ "$OS" == "macos" && -f "$DOTFILES_DIR/macos/defaults.sh" ]]; then
            log_info "Applying macOS defaults..."
            source "$DOTFILES_DIR/macos/defaults.sh"
        fi

        echo ""
        log_success "Installation complete! Restart your shell to apply changes."
        ;;

    uninstall)
        log_info "Removing all symlinks..."
        unlink_all "$DOTFILES_DIR"
        log_success "Uninstall complete."
        ;;

    link)
        log_info "Linking configs only (no package install)..."
        link_shared "$DOTFILES_DIR"
        link_platform "$DOTFILES_DIR" "$OS"
        log_success "Linking complete."
        ;;

    *)
        echo "Usage: $0 [install|uninstall|link]"
        echo ""
        echo "  install    Install packages and link configs (default)"
        echo "  uninstall  Remove all symlinks"
        echo "  link       Link configs only (skip package install)"
        exit 1
        ;;
esac
