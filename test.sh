#!/bin/bash
# อ่านค่าจาก online และ online_app แล้วเขียนไฟล์ .json ให้ตรงกัน

while true; do
    sleep 15s  # เว้นจังหวะให้ sync กับสคริปต์หลัก

    # ตรวจสอบว่าไฟล์ online_app มีอยู่และไม่ว่าง
    if [[ -s /var/www/html/server/online_app ]]; then
        cat /var/www/html/server/online_app > /var/www/html/server/online_app.json
    fi

    # ตรวจสอบว่าไฟล์ online มีอยู่และไม่ว่าง
    if [[ -s /var/www/html/server/online ]]; then
        value=$(cat /var/www/html/server/online)
        echo "$value" > /var/www/html/server/online.json
    fi
done
