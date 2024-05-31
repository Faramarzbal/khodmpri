#!/bin/bash

echo "================================="
echo "       Timeshift Manager         "
echo "================================="
echo "1. نصب Timeshift"
echo "2. گرفتن اسنپ‌شات"
echo "3. مشاهده لیست اسنپ‌شات‌ها"
echo "4. بازگرداندن اسنپ‌شات"
echo "5. خروج"
echo "================================="
read -p "لطفاً یک گزینه را انتخاب کنید [1-5]: " choice

install_timeshift() {
    sudo add-apt-repository -y ppa:teejee2008/ppa
    sudo apt update
    sudo apt install -y timeshift
    echo "Timeshift با موفقیت نصب شد."
}

take_snapshot() {
    sudo timeshift --create --comments "Manual Snapshot"
    echo "اسنپ‌شات جدید با موفقیت گرفته شد."
}

list_snapshots() {
    sudo timeshift --list
}

restore_snapshot() {
    sudo timeshift --list
    read -p "لطفاً نام اسنپ‌شات مورد نظر برای بازگردانی را وارد کنید: " snapshot
    sudo timeshift --restore --snapshot "$snapshot"
}

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
        echo "خروج..."
        exit 0
        ;;
    *)
        echo "گزینه نامعتبر است. لطفاً دوباره امتحان کنید."
        ;;
esac
