#!/bin/bash

source ../../remoteDebInstallHelper.bash

. ../../updatePackageIndex.bash
sudo apt install -y libasound2-dev \
    libgtk-3-dev \
    libnss3-dev \
    fonts-noto \
    fonts-noto-cjk

installRemoteDeb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# Extra chrome tweaks
## Disables welcome screen (without sudo for user directory)
t="$HOME/.config/google-chrome/First Run"
mkdir -p "${t%/*}" 2>/dev/null || true
touch "$t" 2>/dev/null || true

## Disables default browser prompt (with proper sudo handling)
t="/etc/opt/chrome/policies/managed/managed_policies.json"
if sudo mkdir -p "${t%/*}" 2>/dev/null; then
    echo '{ "DefaultBrowserSettingEnabled": false }' | sudo tee "$t" > /dev/null
else
    echo "Warning: Could not create Chrome policies directory. Skipping default browser setting."
fi

# Add environment variable for sandboxing
echo "export QTWEBENGINE_DISABLE_SANDBOX=1" >> ~/.bashrc

echo "Chrome installation completed successfully!"
echo "Note: You may need to restart your terminal or run 'source ~/.bashrc' for environment changes to take effect."