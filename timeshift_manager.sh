#!/bin/bash

menu() {
    echo "================================="
    echo "       Timeshift Manager         "
    echo "================================="
    echo "1. Install Timeshift"
    echo "2. Take a Snapshot"
    echo "3. View Snapshot List"
    echo "4. Restore Snapshot"
    echo "5. Create a ZIP Archive from a Snapshot"
    echo "6. Exit"
    echo "================================="
    read -p "Please select an option [1-6]: " choice
}

install_timeshift() {
    sudo add-apt-repository -y ppa:teejee2008/ppa
    sudo apt update
    sudo apt install -y timeshift
    echo "Timeshift installed successfully."
    read -p "Return to the main menu? (y/n): " return_choice
    if [ "$return_choice" == "y" ]; then
        main
    fi
}

take_snapshot() {
    sudo timeshift --create --comments "Manual Snapshot"
    echo "New snapshot taken successfully."
    read -p "Return to the main menu? (y/n): " return_choice
    if [ "$return_choice" == "y" ]; then
        main
    fi
}

list_snapshots() {
    sudo timeshift --list
    read -p "Return to the main menu? (y/n): " return_choice
    if [ "$return_choice" == "y" ]; then
        main
    fi
}

restore_snapshot() {
    sudo timeshift --list
    read -p "Please enter the name of the snapshot to restore: " snapshot
    sudo timeshift --restore --snapshot "$snapshot"
    read -p "Return to the main menu? (y/n): " return_choice
    if [ "$return_choice" == "y" ]; then
        main
    fi
}

create_zip_archive() {
    echo "Available snapshots for archiving:"
    ls -d /run/timeshift/backup/timeshift/snapshots/*/ | awk -F'/' '{print $NF}'
    read -p "Enter the name of the snapshot directory to create a ZIP archive: " snapshot_dir
    if [ -d "/run/timeshift/backup/timeshift/snapshots/$snapshot_dir" ]; then
        sudo zip -r "/run/timeshift/backup/timeshift/snapshots/${snapshot_dir}.zip" "/run/timeshift/backup/timeshift/snapshots/$snapshot_dir"
        echo "ZIP archive created successfully."
    else
        echo "Snapshot directory not found."
    fi
    read -p "Return to the main menu? (y/n): " return_choice
    if [ "$return_choice" == "y" ]; then
        main
    fi
}

main() {
    menu
    case $choice in
        1)
            install_timeshift
            ;;
        2)
            take_snapshot
            ;;
        3)
            list_snapshots
            ;;
        4)
            restore_snapshot
            ;;
        5)
            create_zip_archive
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            main
            ;;
    esac
}

main
