#!/bin/bash

set -e

create_home_directory() {
    if [ ! -d "/home/$1" ]; then
        sudo mkdir -p /home/$1
        sudo chown -R $1:$1 /home/$1
    fi
}

get_username() {
    if [ -z "$1" ]; then
        echo "Please provide a username"
        exit 1
    fi

    for user in $(seq 1 "$@"); do
        create_home_directory $user
    done
}

echo "This script will create home directories for users"
echo "Enter the number of users you want to create"
read -r response

get_username $response