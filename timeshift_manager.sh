#!/bin/bash

# Function to display the menu
display_menu() {
    echo "Please choose an option:"
    echo "1. Install Timeshift"
    echo "2. Create a new snapshot"
    echo "3. List snapshots"
    echo "4. Restore system from a snapshot"
    echo "5. Compress a snapshot to tar.gz"
    echo "6. Exit"
}

# Function to install Timeshift
install_timeshift() {
    echo "Installing Timeshift..."
    sudo apt update
    sudo apt install -y timeshift
    echo "Timeshift has been successfully installed."
}

# Function to create a new snapshot
create_snapshot() {
    echo "Creating a new snapshot..."
    sudo timeshift --create --comments "New snapshot"
    echo "New snapshot created successfully."
}

# Function to list snapshots
list_snapshots() {
    echo "Available snapshots:"
    sudo timeshift --list
}

# Function to restore system from a snapshot
restore_snapshot() {
    read -p "Enter the name of the snapshot to restore: " snapshot
    echo "Restoring system from snapshot $snapshot..."
    sudo timeshift --restore --snapshot "$snapshot"
    echo "System restored successfully from snapshot $snapshot."
}

# Function to compress a snapshot to tar.gz
compress_snapshot() {
    read -p "Enter the full path of the snapshot folder to compress: " snapshot_folder
    read -p "Enter the name of the output tar.gz file (e.g., archive.tar.gz): " output_file
    echo "Compressing snapshot $snapshot_folder to $output_file..."
    tar -czvf "$output_file" "$snapshot_folder"
    echo "Snapshot compressed successfully to $output_file."
}

# Function to ask user to return to menu or exit
ask_return_or_exit() {
    echo
    echo "Would you like to:"
    echo "1. Return to the main menu"
    echo "2. Exit the script"
    read -p "Enter your choice (1-2): " return_choice

    case $return_choice in
        1)
            return 0
            ;;
        2)
            echo "Exiting the script. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Exiting the script."
            exit 1
            ;;
    esac
}

# Main script logic
while true; do
    display_menu
    read -p "Enter your choice (1-6): " choice

    case $choice in
        1)
            install_timeshift
            ;;
        2)
            create_snapshot
            ;;
        3)
            list_snapshots
            ;;
        4)
            restore_snapshot
            ;;
        5)
            compress_snapshot
            ;;
        6)
            echo "Exiting the script. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    ask_return_or_exit
done
