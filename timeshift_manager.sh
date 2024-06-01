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
# Function to send ZIP Archive to Telegram
send_to_telegram() {
    python3 << END
import telebot
import os

# Replace 'YOUR_BOT_TOKEN' with your bot's token
bot = telebot.TeleBot('YOUR_BOT_TOKEN')

# Function to send a file to admin
def send_file_to_admin(chat_id, file_path):
    try:
        bot.send_document(chat_id, open(file_path, 'rb'))
        print("File sent successfully.")
    except Exception as e:
        print("Error sending file:", e)

# Main function
def main():
    # Get bot token and admin chat id from user
    bot_token = input("Enter your bot token: ")
    admin_chat_id = input("Enter your admin chat id: ")

    # Get file path from user
    file_path = input("Enter the full path of the ZIP file to send: ")

    # Send file to admin
    send_file_to_admin(admin_chat_id, file_path)

if __name__ == "__main__":
    main()
END
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
    read -p "Enter your choice (1-5): " choice

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
        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    ask_return_or_exit
done
