#!/bin/bash

set -e

install_docker_debian() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/$1/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$1 $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo systemctl start docker
    sudo systemctl enable docker
}

install_docker_centos() {
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce
    sudo systemctl start docker
    sudo systemctl enable docker
}

install_docker_fedora() {
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce
    sudo systemctl start docker
    sudo systemctl enable docker
}

install_docker_opensuse() {
    sudo zypper install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
}


get_os() {
    source /etc/os-release;
    if [ $NAME == "ubuntu" ]; then
        install_docker_ubuntu
    elif [ $NAME == "centos" ]; then
        install_docker_centos
    elif [ $NAME == "debian" ]; then
        install_docker_debian
    elif [ $NAME == "fedora" ]; then
        install_docker_fedora
    elif [ $NAME == "openSUSE Leap" ]; then
        install_docker_opensuse
    else
        echo "Unsupported OS"
    fi
    
}

AUTO_CONFIRM="false"

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

echo "This script will attempt to install Docker on your system (Linux only)"

if [ "$AUTO_CONFIRM" == "true" ]; then
    response="y"
else
    echo "You want to continue? (y/n)"
    read response
fi

if [[ "$response" == "y" ]]; then
    get_os
    echo "Installation complete."
    exit 0
else
    echo "Exiting..."
fi