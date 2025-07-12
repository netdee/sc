#!/bin/bash
# เสริม online_app ให้สร้างไฟล์ .json เพิ่มอีก 2 ไฟล์

while true; do
    sleep 15s  # เว้นจังหวะให้ sync กับสคริปต์หลัก

    if [[ -f /var/www/html/server/online_app ]]; then
        cp /var/www/html/server/online_app /var/www/html/server/online_app.json
    fi

    if [[ -f /var/www/html/server/online ]]; then
        cp /var/www/html/server/online /var/www/html/server/online.json
    fi
done
