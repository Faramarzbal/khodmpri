#!/bin/bash

TELEGRAM_TOKEN=""
CHAT_ID=""

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
    echo "5. Create a ZIP Archive from a Snapshot (ایجاد فایل فشرده ZIP از یک اسنپ‌شات)"
    echo "6. Configure Telegram Bot (پیکربندی ربات تلگرام)"
    echo "7. Exit (خروج)"
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

# Function to create a ZIP archive from a snapshot
create_zip_from_snapshot() {
    local snapshot_dir="/run/timeshift/backup/timeshift/snapshots"
    echo "Available snapshots in $snapshot_dir:"
    ls "$snapshot_dir"
    
    read -p "Please enter the name of the snapshot folder you want to archive (لطفاً نام پوشه اسنپ‌شات مورد نظر خود را وارد کنید): " snapshot_folder
    read -p "Please enter the name for the ZIP archive (لطفاً نامی برای فایل فشرده ZIP وارد کنید): " zip_name

    if [ -d "$snapshot_dir/$snapshot_folder" ]; then
        zip -r "$zip_name.zip" "$snapshot_dir/$snapshot_folder"
        echo "Snapshot has been archived successfully. (اسنپ‌شات با موفقیت به فایل فشرده ZIP تبدیل شد.)"
        send_zip_via_telegram "$zip_name.zip"
    else
        echo "Snapshot folder does not exist. (پوشه اسنپ‌شات وجود ندارد.)"
    fi
    
    ask_to_return
}

# Function to configure Telegram bot
configure_telegram() {
    read -p "Please enter your Telegram bot token (لطفاً توکن ربات تلگرام خود را وارد کنید): " TELEGRAM_TOKEN
    read -p "Please enter your chat ID (لطفاً چت آی‌دی خود را وارد کنید): " CHAT_ID
    echo "Telegram bot configured successfully. (ربات تلگرام با موفقیت پیکربندی شد.)"
    ask_to_return
}

# Function to send ZIP file via Telegram
send_zip_via_telegram() {
    local zip_file="$1"
    if [[ -z "$TELEGRAM_TOKEN" || -z "$CHAT_ID" ]]; then
        echo "Telegram bot token or chat ID is not configured. (توکن ربات تلگرام یا چت آی‌دی پیکربندی نشده است.)"
        return
    fi
    curl -F chat_id="$CHAT_ID" -F document=@"$zip_file" "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendDocument"
    echo "ZIP file sent via Telegram successfully. (فایل فشرده با موفقیت از طریق تلگرام ارسال شد.)"
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
    read -p "Please choose an option [1-7]: " choice
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
            create_zip_from_snapshot
            ;;
        6)
            configure_telegram
            ;;
        7)
            echo "Exiting... (در حال خروج...)"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again. (گزینه نامعتبر است. لطفاً دوباره امتحان کنید.)"
            ;;
    esac
done
