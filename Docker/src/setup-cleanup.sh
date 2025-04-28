#!/bin/bash

# Remove old and unsued docker inages, volumns, networks

clean_up(){
    if ! command -v docker &> /dev/null; then
        echo "docker is not install."
    else

        echo "Removing unused images..."
        docker image prune -f

        echo "Removing unused volumes..."
        docker volume prune -f

        echo "Removing unused networks..."
        docker network prune -f

        echo "Docker cleanup completed!"
        echo "Do you want to set this as a cron job? (y/n)"
        read -r response
        if [[ "$response" == "y" || "$response" == "yes" ]]
        then
            echo "Setting up cron job..."
            echo "0 0 * * * /bin/bash ~/docker_cleanup.sh" | crontab -
            echo "Cron job set up successfully!"
        else
            echo "Cron job not set up!"
        fi
    fi
}

echo "This script will remove all unsued docker images"

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
    clean_up()
    echo "Job finish complete."
    exit 0
else
    echo "Exiting..."
fi


