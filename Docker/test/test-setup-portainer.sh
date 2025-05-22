#!/bin/bash

# Set up a test environment
sudo apt install bats -y

setup() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed."
        exit 1
    fi

    if ! systemctl is-active --quiet docker; then
        echo "Docker is not running"
        exit 1
    fi

    if docker ps | grep -q "portainer"; then
        echo "Portainer is already running"
        exit 1
    fi
}

@test "Check if the setup-portainer returns correct output" {
    run bash ../src/setup-portainer.sh -y
    [ "$status" -eq 0 ]
    [ "$output" == "Job finish complete." ]
}

@test "Check if the script handle the case of missing docker" {
    run bash ../src/setup-portainer.sh -y
    [ "$status" -eq 1 ]
    [ "$output" == "Docker is not installed. Please install Docker first." ]
}

@test "Check if the portainer actually running"{
    run docker ps | grep -q "portainer"
    [ "$status" -eq 0 ]
    [ "$output" == "portainer" ]}

teardown() {
    echo "Cleaning up after test..."
    # In case something fail and i dont want these messed up the settings
    docker stop portainer
    docker rm portainer
    docker volume rm portainer_data
}