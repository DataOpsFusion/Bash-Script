#!/bin/bash

# Set up a test environment
sudo apt install bats -y

setup() {
    # Check if user abc is 
    cat /etc/passwd | grep -q "abc"
    if [ $? -eq 0 ]; then
        echo "User abc already exists"
        exit 1
    fi
}

@test "Check if the add-users.sh returns a correct ouput"{
    run bash ../src/add-users.sh -y
    [ "$status" -eq 0 ]
    [ "$output" == "Job finish complete." ]
}
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