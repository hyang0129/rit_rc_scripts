#!/bin/bash
# Script to set up SSH keys for git on Empire AI
# Run this script after logging into empireai: ssh -i C:\Users\HongM\.ssh\empireai-openssh hyang1@alpha1.empire-ai.org

echo "=== Setting up SSH keys for Git on Empire AI ==="
echo ""

# Prompt for email
read -p "Enter your email address for the SSH key: " USER_EMAIL
if [ -z "$USER_EMAIL" ]; then
    USER_EMAIL="your_email@example.com"
fi

# Step 1: Generate SSH key pair
echo ""
echo "Step 1: Generating SSH key pair for Git..."
echo "Press Enter when prompted for file location (default is fine)"
echo "Enter a passphrase when prompted (or leave empty for no passphrase)"
ssh-keygen -t ed25519 -C "$USER_EMAIL"

# Step 2: Start SSH agent and add key
echo ""
echo "Step 2: Starting SSH agent and adding key..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Step 3: Display the public key
echo ""
echo "Step 3: Your public SSH key (copy this to GitHub/GitLab):"
echo "========================================================"
cat ~/.ssh/id_ed25519.pub
echo "========================================================"
echo ""

# Step 4: Configure SSH
echo "Step 4: Configuring SSH..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Create or append to SSH config
cat >> ~/.ssh/config << 'EOF'

# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes

# GitLab
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Next steps:"
echo "1. Copy the public key above"
echo "2. Add it to your Git provider:"
echo "   - GitHub: https://github.com/settings/keys"
echo "   - GitLab: https://gitlab.com/-/profile/keys"
echo "3. Test the connection:"
echo "   ssh -T git@github.com"
echo "   OR"
echo "   ssh -T git@gitlab.com"
echo "4. Clone your repository:"
echo "   git clone git@github.com:username/repo.git"
echo ""
