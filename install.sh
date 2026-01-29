#!/bin/zsh

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "${BLUE}RZ Dotfiles Installer${NC}"
echo "=====================\n"

# Function to backup existing file
backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1.backup.$(date +%s)"
        echo "${YELLOW}✓ Backed up $1${NC}"
    fi
}

# Function to link file
link_file() {
    local src="$1"
    local dest="$2"
    
    if [ ! -f "$src" ]; then
        echo "${YELLOW}⚠ Source not found: $src${NC}"
        return 1
    fi
    
    backup_file "$dest"
    ln -sf "$src" "$dest"
    echo "${GREEN}✓ Linked $dest${NC}"
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR" || exit 1

# VSCode
echo "\n${BLUE}Setting up VSCode...${NC}"
if [ -d ~/Library/Application\ Support/Code/User ]; then
    link_file "$DOTFILES_DIR/vscode/settings.json" ~/Library/Application\ Support/Code/User/settings.json
    echo "${GREEN}✓ VSCode configured${NC}"
else
    echo "${YELLOW}⚠ VSCode not found${NC}"
fi

# Shell
echo "\n${BLUE}Setting up Shell...${NC}"
if grep -q "source ~/.zsh_aliases" ~/.zshrc; then
    echo "${GREEN}✓ .zsh_aliases already sourced${NC}"
else
    backup_file ~/.zshrc
    echo "source ~/.zsh_aliases" >> ~/.zshrc
    echo "${GREEN}✓ Added .zsh_aliases to ~/.zshrc${NC}"
fi
link_file "$DOTFILES_DIR/shell/.zsh_aliases" ~/.zsh_aliases

# Git
echo "\n${BLUE}Setting up Git...${NC}"
git config --global core.excludesfile ~/.gitignore_global
link_file "$DOTFILES_DIR/git/.gitignore_global" ~/.gitignore_global
echo "${GREEN}✓ Global gitignore configured${NC}"

# Tools
echo "\n${BLUE}Setting up Tool Configs...${NC}"
link_file "$DOTFILES_DIR/tools/.prettierrc" ~/.prettierrc
link_file "$DOTFILES_DIR/tools/.editorconfig" ~/.editorconfig
echo "${GREEN}✓ Tool configs installed${NC}"

# SSH (example only)
echo "\n${BLUE}SSH Configuration${NC}"
echo "${YELLOW}ℹ SSH config example copied to: ~/.ssh/config.example${NC}"
cp "$DOTFILES_DIR/ssh/config.example" ~/.ssh/config.example
echo "Copy or merge this manually: cp ~/.ssh/config.example ~/.ssh/config"

# Git config (already handled by setup-git-config.sh)
echo "\n${BLUE}Git Configuration${NC}"
echo "${YELLOW}ℹ Run ./setup-git-config.sh to configure Git for your folders${NC}"

# Done
echo "\n${GREEN}✓ Installation complete!${NC}"
echo "\nNext steps:"
echo "  1. Reload shell: source ~/.zshrc"
echo "  2. Run: ./setup-git-config.sh"
echo "  3. Review and update configs as needed"
echo "  4. Check backups: *.backup.*"
