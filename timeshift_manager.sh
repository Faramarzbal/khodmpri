#!/bin/bash

SNAPSHOT_PATH="/timeshift/snapshots"

# Function to display the menu
display_menu() {
    echo "Please choose an option:"
    echo "1. Install Timeshift"
    echo "2. Create a new snapshot"
    echo "3. List snapshots"
    echo "4. Restore system from a snapshot"
    echo "5. Create a ZIP Archive from a snapshot"
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

# Function to create a ZIP Archive from a snapshot
compress_snapshot() {
    echo "Available snapshots in $SNAPSHOT_PATH:"
    ls "$SNAPSHOT_PATH"
    
    read -p "Enter the name of the snapshot folder to compress: " snapshot_folder
    snapshot_folder_path="$SNAPSHOT_PATH/$snapshot_folder"
    
    if [ -d "$snapshot_folder_path" ]; then
        read -p "Enter the name of the output tar.gz file (e.g., archive.tar.gz): " output_file
        echo "Compressing snapshot $snapshot_folder_path to $output_file..."
        tar -czvf "$output_file" -C "$SNAPSHOT_PATH" "$snapshot_folder"
        echo "Snapshot compressed successfully to $output_file."
    else
        echo "Snapshot folder $snapshot_folder does not exist."
    fi
}

# Function to ask user to return to menu or exit
ask_return_or_exit() {
    echo
    echo "Woul
