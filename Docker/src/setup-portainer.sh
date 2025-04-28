#!/bin/bash

check_requirement() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Please install Docker first."
        exit 1
    fi
}

install_portainer() {
    docker volume create portainer_data
    docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --name portainer portainer/portainer
}

echo "This script will attempt to install Portainer on your system"
echo "You want to continue? (y/n)"
read response

if [[ $response == "y" ]]; then
    check_requirement
    install_portainer
else
    echo "Exiting..."
fi