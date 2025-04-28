#!/bin/bash

echo "This script will attempt to tools to set up virtual manager"
echo "This script will install qemu-kvm, libvirt-daemon-system, libvirt-clients, bridge-utils, and virt-manager"
echo "You want to continue? (y/n)"
read response

if [[ $response == "y" ]]; then
    sudo apt-get update
    sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    sudo apt-get install virt-manager -y
    sudo usermod -aG libvirt $(whoami)
    sudo usermod -aG kvm $(whoami)
    sudo mkdir -p /var/lib/libvirt/images
    sudo chown -R $(whoami):$(whoami) /var/lib/libvirt/images
    echo "Virtual machine installed successfully"
else
    echo "Exiting..."
fi