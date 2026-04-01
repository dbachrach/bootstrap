#!/usr/bin/env bash
# Generate an SSH key if one doesn't already exist

KEY="$HOME/.ssh/id_ed25519"

if [[ -f "$KEY" ]]; then
  echo "SSH key already exists at $KEY, skipping"
  exit 0
fi

echo "Generating SSH key..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

read -rp "Enter email for SSH key (e.g. you@example.com): " email
ssh-keygen -t ed25519 -C "$email" -f "$KEY" -N ""

# Start ssh-agent and add the key
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain "$KEY"

# Configure ssh to use keychain
SSH_CONFIG="$HOME/.ssh/config"
if ! grep -q "UseKeychain" "$SSH_CONFIG" 2>/dev/null; then
  cat >> "$SSH_CONFIG" <<EOF

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
fi
chmod 600 "$SSH_CONFIG"

echo ""
echo "SSH key generated. Your public key:"
echo ""
cat "${KEY}.pub"
echo ""
echo "Copy the key above and add it to GitHub:"
echo "  https://github.com/settings/ssh/new"
echo ""

# Copy to clipboard for convenience
pbcopy < "${KEY}.pub"
echo "Public key copied to clipboard."
