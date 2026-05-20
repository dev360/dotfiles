#!/usr/bin/env bash

# ============================================================================
# Dotfiles Installation Script
# Platform-agnostic installer for macOS (Homebrew) and Arch Linux (pacman/yay)
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "\n${BLUE}==> $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# Platform Detection
# ============================================================================

detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            PLATFORM="macos"
            print_success "Detected macOS"
            ;;
        Linux*)
            if [ -f /etc/arch-release ]; then
                PLATFORM="arch"
                print_success "Detected Arch Linux"
            else
                PLATFORM="linux"
                print_success "Detected Linux (generic)"
            fi
            ;;
        *)
            print_error "Unsupported platform: $(uname -s)"
            exit 1
            ;;
    esac
}

# ============================================================================
# Package Manager Setup
# ============================================================================

setup_package_manager() {
    print_header "Setting up package manager"

    if [ "$PLATFORM" = "macos" ]; then
        if ! command_exists brew; then
            print_warning "Homebrew not found. Installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Setup Homebrew in PATH for this session
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi

            print_success "Homebrew installed"
        else
            print_success "Homebrew already installed"
            brew update
        fi
        PKG_MANAGER="brew"
        PKG_INSTALL="brew install"
        PKG_CASK_INSTALL="brew install --cask"

    elif [ "$PLATFORM" = "arch" ]; then
        print_success "Using pacman/yay"

        # Check if yay (AUR helper) is installed
        if ! command_exists yay; then
            print_warning "yay not found. Installing..."
            sudo pacman -S --needed --noconfirm base-devel git
            cd /tmp
            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si --noconfirm
            cd ~
            print_success "yay installed"
        else
            print_success "yay already installed"
        fi

        PKG_MANAGER="yay"
        PKG_INSTALL="yay -S --needed --noconfirm"

        # Update system
        sudo pacman -Syu --noconfirm
    fi
}

# ============================================================================
# Package Installation
# ============================================================================

install_package() {
    local name=$1
    local brew_name=$2
    local arch_name=$3
    local is_cask=${4:-false}

    if command_exists "$name"; then
        print_success "$name already installed"
        return 0
    fi

    print_header "Installing $name"

    if [ "$PLATFORM" = "macos" ]; then
        if [ "$is_cask" = true ]; then
            $PKG_CASK_INSTALL "$brew_name" || print_warning "Failed to install $name"
        else
            $PKG_INSTALL "$brew_name" || print_warning "Failed to install $name"
        fi
    elif [ "$PLATFORM" = "arch" ]; then
        $PKG_INSTALL "$arch_name" || print_warning "Failed to install $name"
    fi

    if command_exists "$name"; then
        print_success "$name installed successfully"
    fi
}

# ============================================================================
# Core Tools Installation
# ============================================================================

install_core_tools() {
    print_header "Installing core tools"

    # Git
    install_package "git" "git" "git"

    # Neovim (required for AstroNvim)
    install_package "nvim" "neovim" "neovim"

    # Essential build tools
    if [ "$PLATFORM" = "arch" ]; then
        $PKG_INSTALL base-devel
    fi
}

# ============================================================================
# Shell & Terminal Tools
# ============================================================================

install_shell_tools() {
    print_header "Installing shell and terminal tools"

    # Zellij - Terminal multiplexer
    install_package "zellij" "zellij" "zellij"

    # Starship - Shell prompt
    install_package "starship" "starship" "starship"

    # Zoxide - Better cd
    install_package "zoxide" "zoxide" "zoxide"

    # Oh-My-Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_header "Installing Oh-My-Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh-My-Zsh installed"
    else
        print_success "Oh-My-Zsh already installed"
    fi

    # Oh-My-Zsh plugins
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
        print_header "Installing zsh-history-substring-search plugin"
        git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
        print_success "zsh-history-substring-search installed"
    else
        print_success "zsh-history-substring-search already installed"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        print_header "Installing zsh-autosuggestions plugin"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        print_success "zsh-autosuggestions installed"
    else
        print_success "zsh-autosuggestions already installed"
    fi
}

# ============================================================================
# Development Tools
# ============================================================================

install_dev_tools() {
    print_header "Installing development tools"

    # Rust & Cargo
    if ! command_exists cargo; then
        print_header "Installing Rust"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        print_success "Rust installed"
    else
        print_success "Rust already installed"
    fi

    # Go
    install_package "go" "go" "go"

    # NVM (Node Version Manager)
    if [ ! -d "$HOME/.nvm" ]; then
        print_header "Installing NVM"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        print_success "NVM installed"
    else
        print_success "NVM already installed"
    fi

    # AstroNvim
    if [ ! -d "$HOME/.config/nvim" ] || [ ! -f "$HOME/.config/nvim/init.lua" ]; then
        print_header "Installing AstroNvim"
        # Backup existing nvim config if it exists
        if [ -d "$HOME/.config/nvim" ]; then
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)"
            print_warning "Backed up existing nvim config"
        fi
        git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
        print_success "AstroNvim template installed"
        print_warning "Note: Your custom nvim config will be symlinked from dotfiles"
    else
        print_success "Nvim config already exists"
    fi
}

# ============================================================================
# Container & Kubernetes Tools
# ============================================================================

install_container_tools() {
    print_header "Installing container and Kubernetes tools"

    # Kubectl
    install_package "kubectl" "kubectl" "kubectl"

    # Kubectx & Kubens
    install_package "kubectx" "kubectx" "kubectx"

    # Docker
    if [ "$PLATFORM" = "macos" ]; then
        install_package "docker" "docker" "" false
    elif [ "$PLATFORM" = "arch" ]; then
        install_package "docker" "" "docker"
        # Enable and start docker service
        if ! systemctl is-active --quiet docker; then
            print_header "Enabling Docker service"
            sudo systemctl enable docker
            sudo systemctl start docker
            sudo usermod -aG docker "$USER"
            print_success "Docker service enabled"
            print_warning "You need to log out and back in for docker group changes to take effect"
        fi
    fi

    # OrbStack (macOS) / Podman (Arch Linux)
    if [ "$PLATFORM" = "macos" ]; then
        if ! command_exists orbstack; then
            print_header "Installing OrbStack"
            $PKG_CASK_INSTALL orbstack || print_warning "Failed to install OrbStack"
        else
            print_success "OrbStack already installed"
        fi
    elif [ "$PLATFORM" = "arch" ]; then
        install_package "podman" "" "podman"
        install_package "podman-compose" "" "podman-compose"
        install_package "podman-docker" "" "podman-docker"
    fi
}

# ============================================================================
# CLI Utilities
# ============================================================================

install_cli_utilities() {
    print_header "Installing CLI utilities"

    # Modern Unix tools
    install_package "bat" "bat" "bat"           # Better cat
    install_package "fzf" "fzf" "fzf"           # Fuzzy finder
    install_package "eza" "eza" "eza"           # Better ls
    install_package "fd" "fd" "fd"              # Better find
    install_package "rg" "ripgrep" "ripgrep"    # Better grep
    install_package "sd" "sd" "sd"              # Better sed
    install_package "dust" "dust" "dust"        # Better du
    install_package "ncdu" "ncdu" "ncdu"        # Disk usage analyzer
    install_package "btop" "btop" "btop"        # Better top
    install_package "hexyl" "hexyl" "hexyl"     # Hex viewer

    # Data tools
    install_package "jq" "jq" "jq"              # JSON processor
    install_package "yq" "yq" "yq"              # YAML processor
    install_package "xsv" "xsv" "xsv"           # CSV toolkit

    # Git tools
    install_package "lazygit" "lazygit" "lazygit"
    install_package "delta" "git-delta" "git-delta"

    # Shell history
    install_package "atuin" "atuin" "atuin"

    # Task runner / dev tool manager
    install_package "mise" "mise" "mise"

    # AI coding assistant (requires Node.js)
    if ! command_exists claude; then
        if command_exists npm; then
            print_header "Installing Claude Code"
            npm install -g @anthropic-ai/claude-code || print_warning "Failed to install Claude Code"
        else
            print_warning "Skipping Claude Code (npm not found - run 'nvm install --lts' first)"
        fi
    else
        print_success "Claude Code already installed"
    fi
}

# ============================================================================
# Fonts
# ============================================================================

install_fonts() {
    print_header "Installing fonts"

    if [ "$PLATFORM" = "macos" ]; then
        # Iosevka Term Nerd Font - strict fixed-width with Nerd Font glyphs
        if brew list --cask font-iosevka-term-nerd-font >/dev/null 2>&1; then
            print_success "Iosevka Term Nerd Font already installed"
        else
            print_header "Installing Iosevka Term Nerd Font"
            $PKG_CASK_INSTALL font-iosevka-term-nerd-font || print_warning "Failed to install Iosevka Term Nerd Font"
        fi
    elif [ "$PLATFORM" = "arch" ]; then
        install_package "iosevka" "" "ttf-iosevka-nerd"
    fi
}

# ============================================================================
# Mise Tasks & Bin Setup
# ============================================================================

# Symlink everything under .config/mise/{tasks,bin} from the dotfiles repo into
# ~/.config/mise. Tasks preserve subdirectory structure; existing non-symlink
# files are left alone so per-machine overrides aren't clobbered.
setup_mise() {
    local dotfiles_dir="$1"
    local src_tasks="$dotfiles_dir/.config/mise/tasks"
    local src_bin="$dotfiles_dir/.config/mise/bin"

    if [ -d "$src_tasks" ]; then
        print_header "Installing mise global tasks"
        mkdir -p "$HOME/.config/mise/tasks"

        # Use shell -x test so we don't depend on BSD vs GNU find's -perm syntax
        # (BSD rejects -perm /111, GNU rejects -perm +111).
        find "$src_tasks" -type f -print0 | while IFS= read -r -d '' task_file; do
            [ -x "$task_file" ] || continue
            local rel_path="${task_file#$src_tasks/}"
            local target_dir="$HOME/.config/mise/tasks/$(dirname "$rel_path")"
            local target_file="$HOME/.config/mise/tasks/$rel_path"

            mkdir -p "$target_dir"

            if [ -L "$target_file" ]; then
                ln -sf "$task_file" "$target_file"
                print_success "Updated symlink: mise task $rel_path"
            elif [ -e "$target_file" ]; then
                print_warning "Skipped mise task $rel_path (file exists, not overwriting)"
            else
                ln -sf "$task_file" "$target_file"
                print_success "Symlinked mise task: $rel_path"
            fi
        done
    fi

    if [ -d "$src_bin" ]; then
        print_header "Installing mise bin scripts"
        mkdir -p "$HOME/.config/mise/bin"
        find "$src_bin" -type f -print0 | while IFS= read -r -d '' bin_file; do
            [ -x "$bin_file" ] || continue
            local bin_name
            bin_name="$(basename "$bin_file")"
            ln -sf "$bin_file" "$HOME/.config/mise/bin/$bin_name"
            print_success "Symlinked mise bin: $bin_name"
        done
    fi
}

# ============================================================================
# Dotfiles Symlink Setup
# ============================================================================

setup_dotfiles() {
    print_header "Setting up dotfiles symlinks"

    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Backup existing files
    backup_if_exists() {
        if [ -e "$1" ] && [ ! -L "$1" ]; then
            local backup="$1.bak.$(date +%Y%m%d_%H%M%S)"
            mv "$1" "$backup"
            print_warning "Backed up $1 to $backup"
        fi
    }

    # Symlink .zshrc
    backup_if_exists "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    print_success "Symlinked .zshrc"

    # Symlink .hushlogin (suppresses "Last login" message)
    ln -sf "$DOTFILES_DIR/.hushlogin" "$HOME/.hushlogin"
    print_success "Symlinked .hushlogin"

    # Symlink .gitconfig (uses [includeIf] for per-directory identities)
    backup_if_exists "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    print_success "Symlinked .gitconfig"

    # Git identity files are per-machine and NOT committed to the dotfiles repo.
    # Prompt for both on first install. Defaults match the dotfiles owner;
    # anyone forking can just type their own.
    mkdir -p "$HOME/.config/git"
    ln -sf "$DOTFILES_DIR/.config/git/ignore" "$HOME/.config/git/ignore"
    print_success "Symlinked global git ignore"

    # Personal identity (~/Projects)
    if [ ! -f "$DOTFILES_DIR/.config/git/personal.gitconfig" ]; then
        local personal_name="" personal_email=""
        printf "Personal git name [dev360]: "
        read -r personal_name
        personal_name="${personal_name:-dev360}"
        printf "Personal git email [c.toivola@gmail.com]: "
        read -r personal_email
        personal_email="${personal_email:-c.toivola@gmail.com}"
        cat > "$DOTFILES_DIR/.config/git/personal.gitconfig" <<EOF
# Per-machine personal identity. NOT committed to dotfiles repo.
[user]
    name = $personal_name
    email = $personal_email
EOF
        print_success "Created personal.gitconfig as $personal_name <$personal_email>"
    fi
    ln -sf "$DOTFILES_DIR/.config/git/personal.gitconfig" "$HOME/.config/git/personal.gitconfig"
    print_success "Symlinked personal.gitconfig"

    # Work identity (~/Code) — no default; blank skips
    if [ ! -f "$DOTFILES_DIR/.config/git/work.gitconfig" ]; then
        local work_name="" work_email=""
        printf "Work git name [dev360]: "
        read -r work_name
        work_name="${work_name:-dev360}"
        printf "Work git email (leave blank to skip): "
        read -r work_email
        if [ -n "$work_email" ]; then
            cat > "$DOTFILES_DIR/.config/git/work.gitconfig" <<EOF
# Per-machine work identity. NOT committed to dotfiles repo.
[user]
    name = $work_name
    email = $work_email
EOF
            print_success "Created work.gitconfig as $work_name <$work_email>"
        else
            cat > "$DOTFILES_DIR/.config/git/work.gitconfig" <<'EOF'
# Per-machine work identity. NOT committed to dotfiles repo.
# Add your work email below.
# [user]
#     name = your-handle
#     email = you@work.example
EOF
            print_warning "Created empty work.gitconfig — edit $DOTFILES_DIR/.config/git/work.gitconfig to set your work email"
        fi
    fi
    ln -sf "$DOTFILES_DIR/.config/git/work.gitconfig" "$HOME/.config/git/work.gitconfig"
    print_success "Symlinked work.gitconfig"

    # Symlink .config directories
    mkdir -p "$HOME/.config"

    # Nvim
    backup_if_exists "$HOME/.config/nvim"
    ln -sf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
    print_success "Symlinked nvim config"

    # Zellij
    backup_if_exists "$HOME/.config/zellij"
    ln -sf "$DOTFILES_DIR/.config/zellij" "$HOME/.config/zellij"
    print_success "Symlinked zellij config"

    # Starship
    backup_if_exists "$HOME/.config/starship.toml"
    ln -sf "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
    print_success "Symlinked starship config"

    # Ghostty
    backup_if_exists "$HOME/.config/ghostty"
    ln -sf "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty"
    print_success "Symlinked ghostty config"

    setup_mise "$DOTFILES_DIR"

    # Create .zshrc.local if it doesn't exist
    if [ ! -f "$HOME/.zshrc.local" ]; then
        cp "$DOTFILES_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
        print_success "Created .zshrc.local from example"
        print_warning "Edit ~/.zshrc.local for machine-specific configurations"
    fi
}

# ============================================================================
# Post-Installation Setup
# ============================================================================

post_install() {
    print_header "Post-installation setup"

    # Set zsh as default shell if not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_header "Changing default shell to zsh"
        chsh -s "$(which zsh)"
        print_success "Default shell changed to zsh"
        print_warning "You need to log out and back in for this to take effect"
    fi

    print_header "Installation complete!"
    echo ""
    print_success "All tools installed successfully"
    echo ""
    echo "Next steps:"
    echo "  1. Log out and back in (for shell and group changes)"
    echo "  2. Edit ~/.zshrc.local for machine-specific configs"
    echo "  3. Run 'source ~/.zshrc' or start a new shell"
    echo "  4. Install Node.js: nvm install --lts"
    echo "  5. Open nvim and run :Lazy sync to install plugins"
    echo ""
}

# ============================================================================
# Main Installation Flow
# ============================================================================

main() {
    print_header "Starting dotfiles installation"
    echo "This script will install development tools and configure your environment"
    echo ""

    detect_platform
    setup_package_manager
    install_core_tools
    install_shell_tools
    install_dev_tools
    install_container_tools
    install_cli_utilities
    install_fonts
    setup_dotfiles
    post_install
}

# Run main installation
main
