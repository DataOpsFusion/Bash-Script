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


echo "This script will install Portainer on your system"
while getopts "y" opt; do
  case ${opt} in
    y )
      AUTO_CONFIRM="true"
      ;;
    \? )
      echo "Usage: cmd [-y]"
      exit 1
      ;;
  esac
done

if [ "$AUTO_CONFIRM" == "true" ]; then
    response="y"
else
    echo "You want to continue? (y/n)"
    read response
fi

if [[ "$response" == "y" ]]; then
    check_requirement()
    install_portainer()
    echo "Job finish complete."
    exit 0
else
    echo "Exiting..."
fi


