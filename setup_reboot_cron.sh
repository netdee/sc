#!/bin/bash

# ฟังก์ชันเพื่อเพิ่มงาน cron
add_cron_job() {
    local cron_schedule="$1"
    # ตรวจสอบว่ามีงาน cron นี้อยู่แล้วหรือไม่
    (crontab -l 2>/dev/null | grep -F "$cron_schedule" > /dev/null) || echo "$cron_schedule" | crontab -
    echo "ตั้งค่าการรีบูทระบบตามตาราง '$cron_schedule' เรียบร้อยแล้ว."
}

# แสดงเมนูให้ผู้ใช้เลือกวันและเวลา
echo "กรุณากำหนดตารางเวลาในการรีบูทระบบ:"
echo "1) ทุกวัน"
echo "2) ทุกสัปดาห์ (เลือกวัน)"
echo "3) ทุกเดือน (เลือกวันที่)"
echo "4) ออกจากโปรแกรม"

read -p "กรุณาเลือกตัวเลือก [1-4]: " choice

case $choice in
    1)
        # รีบูททุกวัน
        read -p "กรุณากรอกเวลาที่ต้องการรีบูท (ในรูปแบบ HH:MM): " time
        CRON_SCHEDULE="0 ${time%:*} * * * /sbin/reboot"
        add_cron_job "$CRON_SCHEDULE"
        ;;
    2)
        # รีบูททุกสัปดาห์
        read -p "กรุณาเลือกวันของสัปดาห์ (0=วันอาทิตย์, 1=วันจันทร์, ... 6=วันเสาร์): " day
        read -p "กรุณากรอกเวลาที่ต้องการรีบูท (ในรูปแบบ HH:MM): " time
        CRON_SCHEDULE="0 ${time%:*} * * $day /sbin/reboot"
        add_cron_job "$CRON_SCHEDULE"
        ;;
    3)
        # รีบูททุกเดือน
        read -p "กรุณาเลือกวันที่ของเดือน (1-31): " day
        read -p "กรุณากรอกเวลาที่ต้องการรีบูท (ในรูปแบบ HH:MM): " time
        CRON_SCHEDULE="0 ${time%:*} $day * * /sbin/reboot"
        add_cron_job "$CRON_SCHEDULE"
        ;;
    4)
        echo "ออกจากโปรแกรม..."
        exit 0
        ;;
    *)
        echo "ตัวเลือกไม่ถูกต้อง ออกจากโปรแกรม..."
        exit 1
        ;;
esac
