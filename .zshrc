# ============================================================================
# Platform-agnostic ZSH Configuration
# ============================================================================

# Helper function to check if command exists
_has() {
  return $( whence $1 >/dev/null )
}

# ============================================================================
# History Configuration
# ============================================================================
HISTFILE=$HOME/.zsh_history
SAVEHIST=100000
HISTSIZE=100000
setopt INC_APPEND_HISTORY  # Immediately appends history instead of overwriting
setopt SHARE_HISTORY       # Shares history across multiple Zsh sessions
setopt HIST_IGNORE_DUPS    # Ignores duplicate commands in history

# ============================================================================
# Platform Detection
# ============================================================================
case "$(uname -s)" in
  Darwin*)
    export PLATFORM="macos"
    ;;
  Linux*)
    export PLATFORM="linux"
    ;;
  *)
    export PLATFORM="unknown"
    ;;
esac

# ============================================================================
# Aliases (Platform-Agnostic)
# ============================================================================
alias k="kubectl"
alias c="clear"
alias cd_c="cd ~/Code/"
alias cd_d="cd ~/Downloads/"
alias cd_p="cd ~/Projects/"
alias clean_swp="find . -name '.*.swp' | xargs rm -f"

# Smart vim function that auto-detects MCP socket path
# Remove any existing vim alias first
unalias vim 2>/dev/null || true
vim() {
  local socket_path=""

  # 1. Check for Claude Code settings in current directory or parent directories
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    # Also check .settings.local.json for backwards compatibility
    if [[ -f "$dir/.mcp.json" ]]; then
      socket_path=$(jq -r '.mcpServers.neovim.env.NVIM_SOCKET_PATH // empty' "$dir/.mcp.json" 2>/dev/null)
      [[ -n "$socket_path" ]] && break
    fi
    dir=$(dirname "$dir")
  done

  # 2. If not found, check global ~/.claude.json
  if [[ -z "$socket_path" && -f "$HOME/.claude.json" ]]; then
    # First try to find workspace-specific neovim config by walking up directories
    local search_dir="$PWD"
    while [[ "$search_dir" != "/" && -z "$socket_path" ]]; do
      socket_path=$(jq -r --arg pwd "$search_dir" '.projects[$pwd].mcpServers.neovim.env.NVIM_SOCKET_PATH // empty' "$HOME/.claude.json" 2>/dev/null)
      [[ -n "$socket_path" ]] && break
      search_dir=$(dirname "$search_dir")
    done

    # Fall back to global mcpServers if no workspace-specific config found
    if [[ -z "$socket_path" ]]; then
      socket_path=$(jq -r '.mcpServers.neovim.env.NVIM_SOCKET_PATH // empty' "$HOME/.claude.json" 2>/dev/null)
    fi
  fi

  # 3. Launch nvim with socket if found, otherwise run normally
  if [[ -n "$socket_path" ]]; then
    command nvim --listen "$socket_path" "$@"
  else
    command nvim "$@"
  fi
}

# Platform-specific ls aliases
if [[ "$PLATFORM" == "macos" ]]; then
  alias ls='ls -G'
  alias ll='ls -alFG'
  alias la='ls -AG'
  alias l='ls -CFG'
else
  alias ls='ls --color=auto'
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
fi

# ============================================================================
# Homebrew (macOS)
# ============================================================================
if [[ "$PLATFORM" == "macos" ]]; then
  # Apple Silicon
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  # Intel Mac
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# ============================================================================
# NVM (Node Version Manager)
# ============================================================================
export NVM_DIR="$HOME/.nvm"

# macOS (Homebrew)
if [[ "$PLATFORM" == "macos" && -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \
    source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
# Linux/Generic
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

# ============================================================================
# Development Tools
# ============================================================================

# Rust/Cargo
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Go
if [[ -d "$HOME/go/bin" ]]; then
  export PATH="$PATH:$HOME/go/bin"
fi

# ============================================================================
# Shell Enhancements
# ============================================================================

# Starship prompt
if _has starship; then
  eval "$(starship init zsh)"
fi

# Zoxide (better cd)
if _has zoxide; then
  eval "$(zoxide init zsh)"
fi

# Kubectl completion (only generate if not already present)
if _has kubectl; then
  if [[ ! -f "${fpath[1]}/_kubectl" ]]; then
    kubectl completion zsh > "${fpath[1]}/_kubectl"
  fi
  autoload -Uz compinit && compinit
fi

# ============================================================================
# Editor
# ============================================================================
if _has nvim; then
  export EDITOR=$(which nvim)
elif _has vim; then
  export EDITOR=$(which vim)
else
  export EDITOR=$(which vi)
fi

# ============================================================================
# Oh-My-Zsh (Optional)
# ============================================================================
# Uncomment if you use Oh-My-Zsh
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="eastwood"
# source $ZSH/oh-my-zsh.sh

# ============================================================================
# Claude MCP Configuration
# ============================================================================
# Add Neovim MCP server with auto-generated socket path for current directory
add_nvim_mcp() {
  # Get the current directory name
  local dir_name="${PWD:t}"
  local socket_path="/tmp/nvim-${dir_name}"

  # Use claude mcp add command to add the neovim server
  echo "Adding Neovim MCP server for project: $PWD"
  echo "Socket path: $socket_path"

  claude mcp add neovim \
    --scope local \
    --transport stdio \
    --env "ALLOW_SHELL_COMMANDS=true" \
    --env "NVIM_SOCKET_PATH=$socket_path" \
    -- npx -y mcp-neovim-server
}

# ============================================================================
# Local Configuration
# ============================================================================
# Source local configuration file if it exists
# Use this for machine-specific settings, secrets, work configs, etc.
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

alias python="python3"
alias pip="pip3"

# Ensure history is flushed before the shell exits, compensating for environment issues
function pre_zsh_exit() {
    # Only if HISTFILE is set and exists, or can be created
    if [[ -n "$HISTFILE" ]]; then
        # Force the shell to write the history to the file
        fc -R
    fi
}

# Trap the EXIT signal and run the function
trap pre_zsh_exit EXIT
