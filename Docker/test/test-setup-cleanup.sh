#!/bin/bash

# Set up a test enviroment 
sudo apt install bats -y

setup() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not install."
    if (systemctl is-active --quite docker)
        echo "Docker is not running"
        exit 1
    else
        # Testing by pull some image on the internet and will be delete IMMEDIATELY 
        docker pull pytorch/pytorch:2.7.0-cuda11.8-cudnn9-runtime
        docker pull postgres
        docker volume create test_size1 test_size2
        docker network create test_network1 test_network2 
}

@test "Check if the setup-clean returns corect ouput" {
    run bash ../src/setup-docker.sh -y
    [ "$status" -eq 0 ]
    [ "$output" == "Job finish complete." ]
}

@test "Docker dummy networks should be deleted" {
    run docker network ls
    [[ "$output" != *"test_network"* ]]
    [[ "$output" != *"test_network2"* ]]
}

@test "Check if the script install the requirement" {
    run docker storage ls
    [[ "$output" != *"test_network"* ]]
    [[ "$output" != *"test_network2"* ]]
}

@test "Check if the script install the requirement" {
    run docker image ls
    [[ "$output" != *"test_network"* ]]
    [[ "$output" != *"test_network2"* ]]
}


teardown() {
    echo "Cleaning up after test..."
    # In case something fail and i dont want these messed up the settings
    docker rmi pytorch/pytorch:2.7.0-cuda11.8-cudnn9-runtime
    docker rmi postgres
    docker volume rm test_size1 test_size2
    docker network rm test_network1 test_network2
}