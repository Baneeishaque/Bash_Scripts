#!/bin/bash

install_google_chrome_ubuntu() {

    local SCRIPT_DIR

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../../remoteDebInstallHelper.bash"
    source "$SCRIPT_DIR/../../install_google_chrome_ubuntu_dependencies.bash"
    
    "$SCRIPT_DIR/../../updatePackageIndex.bash"
    install_google_chrome_ubuntu_dependencies

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
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_google_chrome_ubuntu
fi
