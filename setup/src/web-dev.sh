#!/bin/bash

set -o pipefail

OS_ID=""; AUTO_CONFIRM="false"

detect_os() {
    if [[ -f /etc/os-release ]]; then
        OS_ID=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
    fi

    if [[ -z "$OS_ID" ]]; then
        printf "Unable to detect operating system.\n" >&2
        return 1
    fi
}

install_vsc() {
    case "$OS_ID" in
        ubuntu|debian)
            printf "Installing Visual Studio Code for Debian-based system...\n"
            if ! wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg; then
                printf "Failed to download or process GPG key.\n" >&2
                return 1
            fi
            sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
            printf "deb [arch=amd64,arm64,ppc64el,s390x signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main\n" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
            rm -f microsoft.gpg
            sudo apt update
            sudo apt install code -y
            ;;

        fedora)
            printf "Installing Visual Studio Code for Fedora...\n"
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
            sudo dnf check-update
            sudo dnf install code -y
            ;;

        arch)
            printf "Installing Visual Studio Code for Arch Linux...\n"
            sudo pacman -Syu code --noconfirm
            ;;

        *)
            printf "Visual Studio Code is not supported on this OS: %s\n" "$OS_ID" >&2
            return 1
            ;;
    esac
}

install_web_dev_tools() {
    case "$OS_ID" in
        ubuntu|debian)
            sudo apt install -y git curl wget nodejs npm
            ;;
        fedora)
            sudo dnf install -y git curl wget nodejs npm
            ;;
        arch)
            sudo pacman -Syu --noconfirm git curl wget nodejs npm
            ;;
        *)
            printf "Package manager not supported for this OS: %s\n" "$OS_ID" >&2
            return 1
            ;;
    esac

    sudo npm install -g typescript @angular/cli create-react-app vue-cli
    printf "Web dev tools installed!\n"
}

main() {
    printf "This script will install web dev tools and Visual Studio Code.\n"

    while getopts "y" opt; do
        case "${opt}" in
            y ) AUTO_CONFIRM="true" ;;
            \? )
                printf "Usage: %s [-y]\n" "$0" >&2
                return 1
                ;;
        esac
    done

    local response
    if [[ "$AUTO_CONFIRM" == "true" ]]; then
        response="y"
    else
        printf "Do you want to continue? (y/n): "
        read -r response
    fi

    if [[ "$response" != "y" ]]; then
        printf "Exiting...\n"
        return 0
    fi

    if ! detect_os; then
        return 1
    fi

    install_web_dev_tools || return 1
    install_vsc || return 1
}

main "$@"