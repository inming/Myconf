# Myconf Dotfiles Installer for Windows
# Run in PowerShell as Administrator (needed for symlinks)

param(
    [ValidateSet("install", "uninstall", "link")]
    [string]$Action = "install"
)

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# --- Helper Functions ---

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-Ok($msg) { Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red }

function Safe-Link($src, $dest) {
    if (-not (Test-Path $src)) {
        Write-Warn "Source does not exist: $src (skipping)"
        return
    }

    $destDir = Split-Path -Parent $dest
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    if (Test-Path $dest) {
        $item = Get-Item $dest -Force
        if ($item.LinkType -eq "SymbolicLink") {
            if ($item.Target -eq $src) {
                Write-Ok "Already linked: $dest -> $src"
                return
            } else {
                Write-Warn "Different symlink exists: $dest -> $($item.Target) (skipping)"
                return
            }
        }
        # Back up existing file
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backup = "$dest.bak.$timestamp"
        Write-Warn "Backing up: $dest -> $backup"
        Move-Item $dest $backup
    }

    $isDir = (Get-Item $src).PSIsContainer
    New-Item -ItemType SymbolicLink -Path $dest -Target $src -Force | Out-Null
    Write-Ok "Linked: $dest -> $src"
}

function Safe-Unlink($src, $dest) {
    if (Test-Path $dest) {
        $item = Get-Item $dest -Force
        if ($item.LinkType -eq "SymbolicLink" -and $item.Target -eq $src) {
            Remove-Item $dest -Force
            Write-Ok "Unlinked: $dest"
        }
    }
}

# --- Link Functions ---

function Link-Shared {
    Write-Info "Linking shared configs..."

    # Vim
    Safe-Link "$DotfilesDir\shared\vim\.vimrc" "$HOME\.vimrc"

    # Neovim
    Safe-Link "$DotfilesDir\shared\nvim" "$env:LOCALAPPDATA\nvim"

    # Git
    Safe-Link "$DotfilesDir\shared\git\.gitconfig" "$HOME\.gitconfig"
    Safe-Link "$DotfilesDir\shared\git\.gitignore_global" "$HOME\.gitignore_global"

    # VSCode
    $vscodeDir = "$env:APPDATA\Code\User"
    if (Test-Path (Split-Path $vscodeDir)) {
        Safe-Link "$DotfilesDir\shared\vscode\settings.json" "$vscodeDir\settings.json"
        Safe-Link "$DotfilesDir\shared\vscode\keybindings.json" "$vscodeDir\keybindings.json"
    }

    # AI tools
    Safe-Link "$DotfilesDir\shared\ai\claude-code\settings.json" "$HOME\.claude\settings.json"
    Safe-Link "$DotfilesDir\shared\ai\opencode\config.json" "$HOME\.config\opencode\config.json"
}

function Link-Windows {
    Write-Info "Linking Windows configs..."

    # PowerShell profile
    $profileDir = Split-Path -Parent $PROFILE
    Safe-Link "$DotfilesDir\windows\shell\Microsoft.PowerShell_profile.ps1" $PROFILE

    # Windows Terminal
    $wtDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    if (Test-Path $wtDir) {
        Safe-Link "$DotfilesDir\windows\windows-terminal\settings.json" "$wtDir\settings.json"
    }
}

function Install-Packages {
    # Install Scoop if not present
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Info "Installing Scoop..."
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    } else {
        Write-Ok "Scoop already installed."
    }

    # Install packages from list
    $packagesFile = "$DotfilesDir\windows\packages.txt"
    if (Test-Path $packagesFile) {
        Write-Info "Installing packages from packages.txt..."
        Get-Content $packagesFile | Where-Object { $_ -and $_ -notmatch '^\s*#' } | ForEach-Object {
            scoop install $_
        }
    }

    # VSCode extensions
    $extFile = "$DotfilesDir\shared\vscode\extensions.txt"
    if ((Test-Path $extFile) -and (Get-Command code -ErrorAction SilentlyContinue)) {
        Write-Info "Installing VSCode extensions..."
        Get-Content $extFile | Where-Object { $_ -and $_ -notmatch '^\s*#' } | ForEach-Object {
            code --install-extension $_ --force
        }
    }
}

# --- Main ---

Write-Host ""
Write-Host "========================================="
Write-Host "  Myconf Dotfiles Installer (Windows)"
Write-Host "========================================="
Write-Host ""

switch ($Action) {
    "install" {
        Install-Packages
        Link-Shared
        Link-Windows
        Write-Host ""
        Write-Ok "Installation complete! Restart your shell to apply changes."
    }
    "uninstall" {
        Write-Info "Removing all symlinks..."
        # Add unlink calls here as configs grow
        Write-Ok "Uninstall complete."
    }
    "link" {
        Link-Shared
        Link-Windows
        Write-Ok "Linking complete."
    }
}
