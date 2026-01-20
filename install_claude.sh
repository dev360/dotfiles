#!/usr/bin/env bash

# ============================================================================
# Claude Code Configuration Installer
# Updates ~/.claude.json MCPs and copies commands from dotfiles
# ============================================================================

set -e  # Exit on error

# Parse arguments
FORCE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -f, --force    Skip confirmation prompts"
            echo "  -h, --help     Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

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
# Prerequisites Check
# ============================================================================

check_prerequisites() {
    print_header "Checking prerequisites"

    if ! command_exists jq; then
        print_error "jq is required but not installed."
        echo "  Install with: brew install jq (macOS) or yay -S jq (Arch)"
        exit 1
    fi
    print_success "jq is installed"

    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SOURCE_CLAUDE_JSON="$DOTFILES_DIR/.claude.json"
    SOURCE_COMMANDS_DIR="$DOTFILES_DIR/.claude/commands"
    TARGET_CLAUDE_JSON="$HOME/.claude.json"
    TARGET_COMMANDS_DIR="$HOME/.claude/commands"

    if [ ! -f "$SOURCE_CLAUDE_JSON" ]; then
        print_error "Source .claude.json not found at: $SOURCE_CLAUDE_JSON"
        exit 1
    fi
    print_success "Source .claude.json found"

    if [ ! -d "$SOURCE_COMMANDS_DIR" ]; then
        print_warning "Source commands directory not found at: $SOURCE_COMMANDS_DIR"
    else
        print_success "Source commands directory found"
    fi
}

# ============================================================================
# MCP Server Management
# ============================================================================

get_mcp_names() {
    local json_file="$1"
    if [ -f "$json_file" ]; then
        jq -r '.mcpServers // {} | keys[]' "$json_file" 2>/dev/null | sort
    fi
}

update_mcp_servers() {
    print_header "Updating MCP servers"

    # Get current MCPs from target (if file exists)
    local current_mcps=""
    if [ -f "$TARGET_CLAUDE_JSON" ]; then
        current_mcps=$(get_mcp_names "$TARGET_CLAUDE_JSON")
    fi

    # Get new MCPs from source
    local new_mcps
    new_mcps=$(get_mcp_names "$SOURCE_CLAUDE_JSON")

    # Find MCPs that will be removed (use comm for set difference)
    local removed_mcps
    removed_mcps=$(comm -23 <(echo "$current_mcps" | sort) <(echo "$new_mcps" | sort) 2>/dev/null || true)

    # Warn about MCPs that will be removed
    if [ -n "$removed_mcps" ]; then
        print_warning "The following MCP servers will be REMOVED:"
        while IFS= read -r mcp; do
            [ -n "$mcp" ] && echo -e "  ${RED}-${NC} $mcp"
        done <<< "$removed_mcps"
        echo ""
        if [ "$FORCE" = true ]; then
            print_warning "Force mode: proceeding without confirmation"
        else
            read -p "Do you want to continue? [y/N] " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_warning "Aborted by user"
                exit 0
            fi
        fi
    fi

    # Show MCPs that will be configured
    echo ""
    print_header "MCP servers to be configured:"
    while IFS= read -r mcp; do
        [ -n "$mcp" ] && echo -e "  ${GREEN}+${NC} $mcp"
    done <<< "$new_mcps"

    # Perform the update
    if [ -f "$TARGET_CLAUDE_JSON" ]; then
        # Merge: take existing file and replace only mcpServers
        local source_mcps
        source_mcps=$(jq '.mcpServers // {}' "$SOURCE_CLAUDE_JSON")

        # Create backup
        local backup="$TARGET_CLAUDE_JSON.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$TARGET_CLAUDE_JSON" "$backup"
        print_success "Backed up existing config to: $backup"

        # Update mcpServers in target
        jq --argjson mcps "$source_mcps" '.mcpServers = $mcps' "$TARGET_CLAUDE_JSON" > "$TARGET_CLAUDE_JSON.tmp"
        mv "$TARGET_CLAUDE_JSON.tmp" "$TARGET_CLAUDE_JSON"
        print_success "Updated mcpServers in $TARGET_CLAUDE_JSON"
    else
        # No existing file, create new one with just mcpServers
        jq '{mcpServers: .mcpServers}' "$SOURCE_CLAUDE_JSON" > "$TARGET_CLAUDE_JSON"
        print_success "Created new $TARGET_CLAUDE_JSON"
    fi
}

# ============================================================================
# Commands Management
# ============================================================================

copy_commands() {
    print_header "Copying Claude commands"

    if [ ! -d "$SOURCE_COMMANDS_DIR" ]; then
        print_warning "No commands directory to copy"
        return 0
    fi

    # Create target directory if needed
    mkdir -p "$TARGET_COMMANDS_DIR"

    # Count command files
    local command_count
    command_count=$(find "$SOURCE_COMMANDS_DIR" -name "*.md" -type f | wc -l | tr -d ' ')

    if [ "$command_count" -eq 0 ]; then
        print_warning "No command files found in $SOURCE_COMMANDS_DIR"
        return 0
    fi

    # Copy each command file
    find "$SOURCE_COMMANDS_DIR" -name "*.md" -type f | while read -r cmd_file; do
        local filename
        filename=$(basename "$cmd_file")
        cp "$cmd_file" "$TARGET_COMMANDS_DIR/$filename"
        print_success "Copied command: $filename"
    done

    print_success "Copied $command_count command(s) to $TARGET_COMMANDS_DIR"
}

# ============================================================================
# Summary
# ============================================================================

print_summary() {
    print_header "Installation complete!"
    echo ""
    echo "MCP servers configured:"
    get_mcp_names "$TARGET_CLAUDE_JSON" | while IFS= read -r mcp; do
        [ -n "$mcp" ] && echo "  - $mcp"
    done
    echo ""
    echo "Commands installed:"
    if [ -d "$TARGET_COMMANDS_DIR" ]; then
        find "$TARGET_COMMANDS_DIR" -name "*.md" -type f | while read -r cmd; do
            local name
            name=$(basename "$cmd" .md)
            echo "  - /$name"
        done
    fi
    echo ""
    print_success "Restart Claude Code for changes to take effect"
}

# ============================================================================
# Main
# ============================================================================

main() {
    print_header "Claude Code Configuration Installer"
    echo "This script will update your Claude Code MCP servers and commands"
    echo ""

    check_prerequisites
    update_mcp_servers
    copy_commands
    print_summary
}

# Run main
main
