#!/bin/bash

echo "Setting up Google Drive with rclone..."

# Create rclone config directory if it doesn't exist
mkdir -p ~/.config/rclone

# Add Google Drive remote configuration
cat >> ~/.config/rclone/rclone.conf << 'EOF'

[gdrive]
type = drive
client_id = 
client_secret = 
scope = drive
root_folder_id = 
service_account_file = 
EOF

echo "Configuration file created. Now run:"
echo "rclone config reconnect gdrive:"
echo ""
echo "This will open a browser to authenticate with Google Drive."
echo "After authentication, you can test with:"
echo "rclone ls gdrive:"