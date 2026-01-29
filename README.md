# RZ Dotfiles

Setup scripts for Git configurations and SSH key management across different project folders.

## Structure

Automatically uses different SSH keys, names, and emails for:
- `~/development/personal` - Personal projects
- `~/development/enterprise` - Enterprise projects  
- `~/development/enterprise/flytap` - Flytap projects (overrides enterprise)

## Setup

### 1. Add SSH Keys (Required First)

Copy your SSH keys to `~/.ssh/`:
```bash
# From your secure location, copy:
# - rz (personal key)
# - rz.pub (personal public key)
# - rz_rsa (flytap key)
# - rz_rsa.pub (flytap public key)

# Set correct permissions
chmod 600 ~/.ssh/rz
chmod 600 ~/.ssh/rz_rsa
chmod 644 ~/.ssh/rz.pub
chmod 644 ~/.ssh/rz_rsa.pub
```

### 2. Run Setup Script

```bash
cd ~/development/personal/rz_dotfiles
chmod +x setup-git-config.sh
./setup-git-config.sh
```

The script will prompt you for:
- Name and email for personal projects
- Name and email for enterprise projects
- Name and email for flytap projects
- SSH key names (defaults provided)

### 3. Verify

Test the configuration:
```bash
# Test personal folder
cd ~/development/personal/test-repo
git config user.name
git config user.email
git config core.sshCommand

# Test enterprise folder
cd ~/development/enterprise/test-repo
git config user.name
git config user.email

# Test flytap folder
cd ~/development/enterprise/flytap/cms
git config user.name
git config user.email
git config core.sshCommand
```

## How It Works

The setup script creates three Git config files:
- `~/.gitconfig-personal` - Personal project config
- `~/.gitconfig-enterprise` - Enterprise project config
- `~/.gitconfig-flytap` - Flytap project config

Git automatically includes these configs based on the directory using `includeIf.gitdir` conditions.

## Files Generated

After running the setup script, you'll have:
- `~/.gitconfig-personal` (auto-generated)
- `~/.gitconfig-enterprise` (auto-generated)
- `~/.gitconfig-flytap` (auto-generated)

**Note:** SSH keys are NOT stored in this repo for security. Keep them local to your machine.

## Security Notes

- SSH private keys should NEVER be committed to Git
- Keep your SSH keys secure on your local machine only
- Use proper file permissions (600 for private keys, 644 for public keys)
- Consider using ssh-agent to manage keys: `ssh-add ~/.ssh/rz` and `ssh-add ~/.ssh/rz_rsa`
