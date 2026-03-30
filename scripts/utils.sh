#!/usr/bin/env bash
# Utility functions for dotfiles management

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect operating system
# Returns: "macos", "linux", or "windows"
detect_os() {
    case "$(uname -s)" in
        Darwin)  echo "macos" ;;
        Linux)   echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)
            log_error "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}

# Create a symlink safely
# Usage: safe_link <source> <destination>
# - If destination is already the correct symlink, skip
# - If destination is an existing file, back it up then link
# - If destination is a different symlink, warn and skip
safe_link() {
    local src="$1"
    local dest="$2"

    if [[ ! -e "$src" ]]; then
        log_warn "Source does not exist: $src (skipping)"
        return 0
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$dest")"

    if [[ -L "$dest" ]]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [[ "$current_target" == "$src" ]]; then
            log_success "Already linked: $dest -> $src"
            return 0
        else
            log_warn "Different symlink exists: $dest -> $current_target (skipping)"
            return 0
        fi
    fi

    if [[ -e "$dest" ]]; then
        local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
        log_warn "Backing up existing file: $dest -> $backup"
        mv "$dest" "$backup"
    fi

    ln -s "$src" "$dest"
    log_success "Linked: $dest -> $src"
}

# Remove a symlink if it points to our dotfiles
# Usage: safe_unlink <source> <destination>
safe_unlink() {
    local src="$1"
    local dest="$2"

    if [[ -L "$dest" ]]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [[ "$current_target" == "$src" ]]; then
            rm "$dest"
            log_success "Unlinked: $dest"
        fi
    fi
}
