#!/bin/bash

set -e

get_username() {
    if [ -z "$1" ]; then
        echo "Please provide a username"
        exit 1
    fi

    for user in $(seq 1 "$@"); do
        create_home_directory $user
    done
}


delete_user() {
    if [ ! -d "/home/$1" ]; then
        sudo useradd -m $1
        echo "User $1 delete successfully"
    fi
}

echo "This script will delete users"
echo "Enter the number of users you want to delete"
read -r response

get_username $response