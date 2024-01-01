#!/bin/bash

echo "1. Update and Upgrade"
echo "2. Exit"

read -p "Enter your choice: " choice

case $choice in
    1)
        echo "Updating and Upgrading..."
        sudo apt update
        sudo apt upgrade -y
        ;;
    2)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac