#!/bin/bash

initialize_flutter() {

    set -e

    local user_version=${1:-master}

    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    source "$SCRIPT_DIR/installHomeBrew.bash"
    source "$SCRIPT_DIR/updateZProfile.bash"
    source "$SCRIPT_DIR/setupSdkManager.bash"
    source "$SCRIPT_DIR/aptInstallHelper.bash"
    source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"

    . "$SCRIPT_DIR/installFVM.bash"

    fvm install master
    fvm spawn "$user_version" create my_app

    cd my_app

    local os
    os=$(uname -s | tr '[:upper:]' '[:lower:]')

    if [[ "$os" == "linux" && -f /etc/lsb-release ]]; then
        . /etc/lsb-release
        if [[ "$DISTRIB_ID" == "Ubuntu" ]]; then

            aptInstallHelper "clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev"

            fvm spawn "$user_version" build linux
        fi
    fi

    if [[ "$os" == "darwin" ]]; then

        local processor
        processor=$(uname -m)

        if [[ "$processor" == "arm64" ]]; then

            if /usr/sbin/softwareupdate --install-rosetta --agree-to-license > /dev/null 2>&1; then

                echo "Rosetta is already installed."

            else
                echo "Installing Rosetta..."
                /usr/sbin/softwareupdate --install-rosetta --agree-to-license
            fi
        fi

        install_homebrew

        if ! xcode-select -p &>/dev/null; then

            echo "Xcode is not installed. Installing Xcode from Apple's official source..."
            open -a "App Store" || open -a "Software Update"
            sudo xcodebuild -license accept
        fi

        if ! command -v pod &>/dev/null; then

            echo "CocoaPods is not installed. Installing CocoaPods..."
            installBrewFormula cocoapods
        fi

        fvm spawn "$user_version" build macos

        if [ -f ~/.zprofile ]; then

            source ~/.zprofile
        
        elif [ -f ~/.zshrc ]; then
        
            source ~/.zshrc
        fi
    fi

    setup_sdkmanager
    fvm spawn "$user_version" build bundle
    fvm spawn "$user_version" build apk
    fvm spawn "$user_version" build appbundle

    fvm spawn "$user_version" build web
    cd ..
    rm -rf my_app

    fvm spawn "$user_version" create my_module --template=module
    cd my_module
    fvm spawn "$user_version" build aar
    cd ..
    rm -rf my_module
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    initialize_flutter "$@"
fi
