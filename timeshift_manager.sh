#!/bin/bash

# Function to display the menu
show_menu() {
    clear
    echo "================================="
    echo "       Timeshift Manager         "
    echo "================================="
    echo "1. Install Timeshift (نصب Timeshift)"
    echo "2. Take a Snapshot (گرفتن اسنپ‌شات)"
    echo "3. List Snapshots (مشاهده لیست اسنپ‌شات‌ها)"
    echo "4. Restore a Snapshot (بازگرداندن اسنپ‌شات)"
    echo "5. Exit (خروج)"
    echo "================================="
}

# Function to install Timeshift
install_timeshift() {
    sudo add-apt-repository -y ppa:teejee2008/ppa
    sudo apt update
    sudo apt install -y timeshift
    echo "Timeshift has been successfully installed. (Timeshift با موفقیت نصب شد.)"
    ask_to_return
}

# Function to take a snapshot
take_snapshot() {
    sudo timeshift --create --comments "Manual Snapshot"
    echo "A new snapshot has been successfully taken. (اسنپ‌شات جدید با موفقیت گرفته شد.)"
    ask_to_return
}

# Function to list snapshots
list_snapshots() {
    sudo timeshift --list
    ask_to_return
}

# Function to restore a snapshot
restore_snapshot() {
    sudo timeshift --list
    read -p "Please enter the snapshot number to restore (لطفاً نام اسنپ‌شات مورد نظر برای بازگردانی را وارد کنید): " snapshot
    sudo timeshift --restore --snapshot "$snapshot"
    ask_to_return
}

# Function to ask if the user wants to return to the main menu
ask_to_return() {
    read -p "Do you want to return to the main menu? [Y/n]: " choice
    case $choice in
        [Yy]* ) ;;
        * ) exit 0;;
    esac
}

# Main script
while true; do
    show_menu
    read -p "Please choose an option [1-5]: " choice
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
            echo "Exiting... (در حال خروج...)"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again. (گزینه نامعتبر است. لطفاً دوباره امتحان کنید.)"
            ;;
    esac
done
