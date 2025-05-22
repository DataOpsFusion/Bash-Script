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

echo "This script will add users and create home directories for them"

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

if [ "$AUTO_CONFIRM" == "true" ]; then
    response="y"
else
    echo "You want to continue? (y/n)"
    read response
fi

if [[ "$response" == "y" ]]; then
    get_username $1
    echo "Job finish complete."
    exit 0
else
    echo "Exiting..."
fi
