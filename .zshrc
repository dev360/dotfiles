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
alias vim="nvim"
alias cd_d="cd ~/Downloads/"
alias cd_p="cd ~/Projects/"
alias clean_swp="find . -name '.*.swp' | xargs rm -f"

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
# Local Configuration
# ============================================================================
# Source local configuration file if it exists
# Use this for machine-specific settings, secrets, work configs, etc.
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
