#!/bin/bash

#!/bin/bash

# Remove old and unsued docker inages, volumns, networks
echo "This script will remove all unsued docker images"
echo "Do you want to continue? (y/n)"
read -r response



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