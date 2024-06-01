#!/bin/bash

# تنظیمات پیش‌فرض
BOT_TOKEN=""
ADMIN_ID=""
SNAPSHOT_DIR="/timeshift/snapshots"

# تنظیمات ربات تلگرام
configure_telegram_bot() {
    read -p "لطفاً توکن ربات تلگرام را وارد کنید: " BOT_TOKEN
    read -p "لطفاً شناسه عددی ادمین را وارد کنید: " ADMIN_ID
}

# ارسال پیام به تلگرام
send_message_to_telegram() {
    local message="$1"
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$ADMIN_ID -d text="$message"
}

# نمایش فایل‌های موجود در مسیر snapshots
list_files() {
    ls "$SNAPSHOT_DIR"
}

# اجرای دستورات بر اساس ورودی
case "$1" in
    "configure")
        configure_telegram_bot
        ;;
    "send-file")
        send_message_to_telegram "فایل‌های موجود در مسیر $SNAPSHOT_DIR:"
        list_files | send_message_to_telegram
        ;;
    *)
        echo "Usage: $0 {configure|send-file}"
        exit 1
        ;;
esac
