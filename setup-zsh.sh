#!/bin/zsh

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "${BLUE}ZSH Terminal Setup${NC}"
echo "==================\n"

# Check if Oh My Zsh is already installed
if [ -d ~/.oh-my-zsh ]; then
    echo "${YELLOW}✓ Oh My Zsh already installed${NC}"
else
    echo "${BLUE}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "${GREEN}✓ Oh My Zsh installed${NC}"
fi

# Install Powerlevel10k theme
echo "\n${BLUE}Installing Powerlevel10k theme...${NC}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k 2>/dev/null || echo "${YELLOW}✓ Powerlevel10k already installed${NC}"

# Update .zshrc to use Powerlevel10k
echo "${BLUE}Configuring Powerlevel10k theme...${NC}"
if grep -q 'ZSH_THEME="powerlevel10k' ~/.zshrc; then
    echo "${YELLOW}✓ Powerlevel10k already set as theme${NC}"
else
    sed -i '' 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    echo "${GREEN}✓ Powerlevel10k set as default theme${NC}"
fi

# Install useful plugins
echo "\n${BLUE}Installing useful plugins...${NC}"

# zsh-syntax-highlighting
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "${GREEN}✓ zsh-syntax-highlighting installed${NC}"
else
    echo "${YELLOW}✓ zsh-syntax-highlighting already installed${NC}"
fi

# zsh-autosuggestions
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "${GREEN}✓ zsh-autosuggestions installed${NC}"
else
    echo "${YELLOW}✓ zsh-autosuggestions already installed${NC}"
fi

# Update .zshrc plugins
echo "${BLUE}Updating plugins in .zshrc...${NC}"
if grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    echo "${YELLOW}✓ Plugins already configured${NC}"
else
    # Backup and update plugins line
    cp ~/.zshrc ~/.zshrc.backup.$(date +%s)
    sed -i '' 's/plugins=(/plugins=(git zsh-syntax-highlighting zsh-autosuggestions /' ~/.zshrc
    echo "${GREEN}✓ Plugins configured${NC}"
fi

# Install Nerd Font (optional but recommended for Powerlevel10k)
echo "\n${BLUE}Installing Nerd Font (recommended)...${NC}"
if [ ! -d ~/Library/Fonts ]; then
    mkdir -p ~/Library/Fonts
fi

# Download and install MesloLGS Nerd Font
echo "${YELLOW}Downloading MesloLGS Nerd Font...${NC}"
fonts=(
    "MesloLGS-NF-Regular.ttf"
    "MesloLGS-NF-Bold.ttf"
    "MesloLGS-NF-Italic.ttf"
    "MesloLGS-NF-Bold-Italic.ttf"
)

for font in "${fonts[@]}"; do
    if [ ! -f ~/Library/Fonts/"$font" ]; then
        curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/$font" -o ~/Library/Fonts/"$font"
    fi
done
echo "${GREEN}✓ MesloLGS Nerd Font installed${NC}"

# Summary
echo "\n${GREEN}✓ ZSH Terminal Setup Complete!${NC}\n"
echo "${BLUE}Next Steps:${NC}"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. When prompted, run: p10k configure"
echo "  3. (Optional) Set font in terminal:"
echo "     Terminal → Preferences → Profiles → Font → Change"
echo "     Select: MesloLGS Nerd Font Regular"
echo ""
echo "${YELLOW}Installed Components:${NC}"
echo "  • Oh My Zsh - Framework for zsh"
echo "  • Powerlevel10k - Beautiful prompt theme"
echo "  • zsh-syntax-highlighting - Command syntax highlighting"
echo "  • zsh-autosuggestions - Fish-like autocomplete"
echo "  • MesloLGS Nerd Font - Font with icons support"
