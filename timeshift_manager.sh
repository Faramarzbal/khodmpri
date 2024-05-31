#!/bin/bash

menu() {
    echo "================================="
    echo "       Timeshift Manager         "
    echo "================================="
    echo "1. Install Timeshift"
    echo "2. Take a Snapshot"
    echo "3. View Snapshot List"
    echo "4. Restore Snapshot"
    echo "5. Exit"
    echo "================================="
    read -p "Please select an option [1-5]: " choice
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
