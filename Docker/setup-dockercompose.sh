#!/bin/bash

set -e

check_requirement() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Please install Docker first."
        echo "Do you want to install Docker? (y/n)"
        read response
        if [[ $response == "y" ]]; then
            install_docker
        else
            echo "Exiting..."
        fi
    elif ! command -v git &> /dev/null; then
        echo "Git is not installed. Please install Git first."
        echo "Do you want to install Git? (y/n)"
        read response
        if [[ $response == "y" ]]; then
            install_git
        else
            echo "Exiting..."
        fi
    fi
}

install_git() {
    sudo apt-get update
    sudo apt-get install git -y
}

install_docker(){
    echo "This script will install Docker on your system"
    echo "By clone this repository: https://github.com/DataOpsFusion/Docker.git"
    echo "You want to continue? (y/n)"
    read response
    if [[ $response == "y" ]]; then
        git clone https://github.com/DataOpsFusion/Docker.git
        cd Docker
        sudo bash setup-docker.sh
    else
        echo "Exiting..."
    fi
}

get_repo() {
    echo "Please provide the repository URL: "
    read -r repo
    git clone $repo && cd $(basename "$repo" .git)
    find . -maxdepth 1 -name "*.yaml" -exec docker-compose -f {} up -d \;
}

echo "This script will attempt to install a docker compose and run the services"
echo "You want to continue? (y/n)"
read response

if [[ $response == "y" ]]; then
    check_requirement
    get_repo
else
    echo "Exiting..."
fi