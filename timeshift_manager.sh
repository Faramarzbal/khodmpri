#!/bin/bash

TELEGRAM_TOKEN=""
CHAT_ID=""
SNAPSHOT_DIR="/run/timeshift/backup/timeshift/snapshots"

# Function to display the main menu
show_main_menu() {
    clear
    echo "================================="
    echo "       Timeshift Manager         "
    echo "================================="
    echo "1. Install Timeshift (نصب Timeshift)"
    echo "2. Take a Snapshot (گرفتن اسنپ‌شات)"
    echo "3. List Snapshots (مشاهده لیست اسنپ‌شات‌ها)"
    echo "4. Restore a Snapshot (بازگرداندن اسنپ‌شات)"
    echo "5. Create a ZIP Archive from a Snapshot (ایجاد فایل فشرده ZIP از یک اسنپ‌شات)"
    echo "6. Send to Telegram (ارسال به تلگرام)"
    echo "7. Exit (خروج)"
    echo "================================="
}

# Function to display the "Send to Telegram" submenu
show_telegram_submenu() {
    clear
    echo "==============================="
    echo "      Send to Telegram        "
    echo "==============================="
    echo "1. Configure Telegram Bot (پیکربندی ربات تلگرام)"
    echo "2. Send Backup File (ارسال فایل بکاپ)"
    echo "3. Return to Main Menu (بازگشت به منوی اصلی)"
    echo "==============================="
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
    echo "Available snapshots in $SNAPSHOT_DIR:"
    ls "$SNAPSHOT_DIR"
    
    read -p "Please enter the name of the snapshot folder you want to archive (لطفاً نام پوشه اسنپ‌شات مورد نظر خود را وارد کنید): " snapshot_folder
    read -p "Please enter the name for the ZIP archive (لطفاً نامی برای فایل فشرده ZIP وارد کنید): " zip_name

    if [ -d "$SNAPSHOT_DIR/$snapshot_folder" ]; then
        zip -r "$SNAPSHOT_DIR/$zip_name.zip" "$SNAPSHOT_DIR/$snapshot_folder"
        echo "Snapshot has been archived successfully. (اسنپ‌شات با موفقیت به فایل فشرده ZIP تبدیل شد.)"
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
send_backup_file_via_telegram() {
    echo "Available snapshots in $SNAPSHOT_DIR:"
    ls "$SNAPSHOT_DIR"

    read -p "Please enter the name of the ZIP file you want to send (لطفاً نام فایل ZIP مورد نظر خود را وارد کنید): " zip_file

    if [ -f "$SNAPSHOT_DIR/$zip_file" ]; then
        if [[ -z "$TELEGRAM_TOKEN" || -z "$CHAT_ID" ]]; then
            echo "Telegram bot token or chat ID is not configured. (توکن ربات تلگرام یا چت آی‌دی پیکربندی نشده است.)"
            ask_to_return
        fi
        curl -F chat_id="$CHAT_ID" -F document=@"$SNAPSHOT_DIR/$zip_file" "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendDocument"
        echo "ZIP file sent via Telegram successfully. (فایل ZIP با موفقیت از طریق تلگرام ارسال شد.)"
    else
        echo "File not found in $SNAPSHOT_DIR. (فایل در $SNAPSHOT_DIR پیدا نشد.)"
    fi

    ask_to_return
}

# Function
