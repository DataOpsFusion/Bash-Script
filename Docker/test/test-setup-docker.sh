#!/bin/bash

set -e

# Set up a test enviroment 
sudo apt install bats -y

@test "Check if the setup-docker returns corect ouput" {
    run bash ../src/setup-docker.sh -y
    [ "$status" -eq 0 ]
    [ "$output" == "Installation complete." ]
}

@test "Check if the script install the requirement" {
    run bash ../src/setup-docker.sh -y
    run systemctl is-active docker
    [ "$status" -eq 0 ]
    [ "$output" = "active" ]
}

teardown() {
    echo "Cleaning up after test..."
}