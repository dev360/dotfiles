# dotfiles

Personal development environment configuration files for macOS and Arch Linux.

## What's Included

**Shell Configuration:**
- `.zshrc` - Platform-agnostic ZSH configuration with OS detection
- `.zshrc.local.example` - Template for machine-specific settings

**Application Configs:**
- `nvim/` - AstroNvim configuration
- `zellij/` - Terminal multiplexer config
- `starship.toml` - Shell prompt customization

**Tools:**
- Modern CLI replacements (bat, eza, fd, ripgrep, etc.)
- Kubernetes utilities (kubectl, kubectx)
- Development tools (Go, Rust, Node via NVM)
- Container platforms (Docker, OrbStack/Podman)

## Installation

Clone and run the installation script:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

The script will:
- Detect your platform (macOS or Arch Linux)
- Install package managers (Homebrew or yay)
- Install all tools with correct package names for your platform
- Symlink configuration files to your home directory
- Backup existing configs before overwriting

## Post-Installation

1. Log out and back in (for shell and group changes)
2. Edit `~/.zshrc.local` for machine-specific configurations
3. Install Node.js LTS: `nvm install --lts`
4. Open nvim and run `:Lazy sync` to install plugins

## Structure

```
dotfiles/
├── .zshrc                    # Main shell config (platform-agnostic)
├── .zshrc.local.example      # Template for local overrides
├── .config/
│   ├── nvim/                 # Neovim configuration
│   ├── zellij/               # Zellij config
│   └── starship.toml         # Starship prompt
├── install.sh                # Installation script
└── README.md
```

## Platform-Specific Notes

**macOS:**
- Uses Homebrew for package management
- Installs OrbStack for containers
- Supports both Apple Silicon and Intel Macs

**Arch Linux:**
- Uses pacman and yay (AUR helper)
- Installs Podman for containers
- Enables Docker service automatically

## Local Configuration

The `.zshrc` automatically sources `~/.zshrc.local` if it exists. Use this file for:
- Machine-specific paths
- API keys and tokens (never commit these)
- Work-specific configurations
- Custom aliases

See `.zshrc.local.example` for a template.
