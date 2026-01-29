#!/bin/zsh

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}Setting up Git configurations...${NC}"

# Ask for personal folder config
echo "\n${BLUE}=== Personal Folder Config ===${NC}"
read "personal_name?Enter your name for personal repos: "
read "personal_email?Enter your email for personal repos: "
read "personal_key?Enter SSH key name for personal (default: rz): "
personal_key=${personal_key:-rz}

# Ask for enterprise folder config
echo "\n${BLUE}=== Enterprise Folder Config ===${NC}"
read "enterprise_name?Enter your name for enterprise repos: "
read "enterprise_email?Enter your email for enterprise repos: "
read "enterprise_key?Enter SSH key name for enterprise (default: rz): "
enterprise_key=${enterprise_key:-rz}

# Ask for flytap folder config
echo "\n${BLUE}=== Flytap Folder Config ===${NC}"
read "flytap_name?Enter your name for flytap repos: "
read "flytap_email?Enter your email for flytap repos: "
read "flytap_key?Enter SSH key name for flytap (default: rz_rsa): "
flytap_key=${flytap_key:-rz_rsa}

# Create .gitconfig-personal
echo "${BLUE}Creating ~/.gitconfig-personal...${NC}"
cat > ~/.gitconfig-personal << EOF
[user]
    name = $personal_name
    email = $personal_email

[core]
    sshCommand = ssh -i ~/.ssh/$personal_key -F /dev/null
EOF

# Create .gitconfig-enterprise
echo "${BLUE}Creating ~/.gitconfig-enterprise...${NC}"
cat > ~/.gitconfig-enterprise << EOF
[user]
    name = $enterprise_name
    email = $enterprise_email

[core]
    sshCommand = ssh -i ~/.ssh/$enterprise_key -F /dev/null
EOF

# Create .gitconfig-flytap (update if exists)
echo "${BLUE}Creating ~/.gitconfig-flytap...${NC}"
cat > ~/.gitconfig-flytap << EOF
[user]
    name = $flytap_name
    email = $flytap_email

[core]
    sshCommand = ssh -i ~/.ssh/$flytap_key -F /dev/null
EOF

# Update global git config with conditional includes
echo "${BLUE}Updating global Git config...${NC}"
# Order matters: more specific paths must come first
git config --global includeIf.gitdir:~/development/enterprise/flytap/.path ~/.gitconfig-flytap
git config --global includeIf.gitdir:~/development/enterprise/.path ~/.gitconfig-enterprise
git config --global includeIf.gitdir:~/development/personal/.path ~/.gitconfig-personal

# Verify
echo "\n${GREEN}✓ Git configuration setup complete!${NC}"
echo "\n${BLUE}Configuration Summary:${NC}"
echo "Personal folder (~/.gitconfig-personal):"
echo "  Name: $personal_name"
echo "  Email: $personal_email"
echo "  SSH Key: ~/.ssh/$personal_key"
echo ""
echo "Enterprise folder (~/.gitconfig-enterprise):"
echo "  Name: $enterprise_name"
echo "  Email: $enterprise_email"
echo "  SSH Key: ~/.ssh/$enterprise_key"
echo ""
echo "Flytap folder (~/.gitconfig-flytap):"
echo "  Name: $flytap_name"
echo "  Email: $flytap_email"
echo "  SSH Key: ~/.ssh/$flytap_key"

# Optional: Test
echo "\n${BLUE}Testing configuration...${NC}"
if [ -d ~/development/enterprise/flytap/cms/.git ]; then
    echo "Flytap test:"
    (cd ~/development/enterprise/flytap/cms && echo "  Name: $(git config user.name)" && echo "  Email: $(git config user.email)" && echo "  SSH: $(git config core.sshCommand)")
fi

if [ -d ~/development/personal ] || [ -d ~/development/enterprise ]; then
    echo "Development test (if repo exists):"
    for dir in ~/development/**/; do
        if [ -d "$dir/.git" ] && [[ ! "$dir" =~ "flytap" ]]; then
            (cd "$dir" && echo "  Name: $(git config user.name)" && echo "  Email: $(git config user.email)")
            break
        fi
    done
fi
