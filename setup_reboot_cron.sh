#!/bin/bash

# ฟังก์ชันเพื่อเพิ่มงาน cron
add_cron_job() {
    local cron_schedule="$1"
    # ตรวจสอบว่ามีงาน cron นี้อยู่แล้วหรือไม่
    if (crontab -l 2>/dev/null | grep -F "$cron_schedule" > /dev/null); then
        echo "งาน cron นี้มีอยู่แล้ว."
    else
        echo "$cron_schedule" | crontab -
        if [ $? -eq 0 ]; then
            echo "ตั้งค่าการรีบูทระบบตามตาราง '$cron_schedule' เรียบร้อยแล้ว."
        else
            echo "ไม่สามารถตั้งค่างาน cron ได้."
        fi
    fi
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
        if [[ ! "$time" =~ ^[0-2][0-9]:[0-5][0-9]$ ]]; then
            echo "รูปแบบเวลาที่ป้อนผิดพลาด. ใช้ HH:MM."
            exit 1
        fi
        CRON_SCHEDULE="0 ${time%:*} * * * /sbin/reboot"
        add_cron_job "$CRON_SCHEDULE"
        ;;
    2)
        # รีบูททุกสัปดาห์
        read -p "กรุณาเลือกวันของสัปดาห์ (0=วันอาทิตย์, 1=วันจันทร์, ... 6=วันเสาร์): " day
        if [[ ! "$day" =~ ^[0-6]$ ]]; then
            echo "ตัวเลขวันของสัปดาห์ไม่ถูกต้อง."
            exit 1
        fi
        read -p "กรุณากรอกเวลาที่ต้องการรีบูท (ในรูปแบบ HH:MM): " time
        if [[ ! "$time" =~ ^[0-2][0-9]:[0-5][0-9]$ ]]; then
            echo "รูปแบบเวลาที่ป้อนผิดพลาด. ใช้ HH:MM."
            exit 1
        fi
        CRON_SCHEDULE="0 ${time%:*} * * $day /sbin/reboot"
        add_cron_job "$CRON_SCHEDULE"
        ;;
    3)
        # รีบูททุกเดือน
        read -p "กรุณาเลือกวันที่ของเดือน (1-31): " day
        if [[ ! "$day" =~ ^[0-9]{1,2}$ ]] || [ "$day" -lt 1 ] || [ "$day" -gt 31 ]; then
            echo "วันที่ไม่ถูกต้อง."
            exit 1
        fi
        read -p "กรุณากรอกเวลาที่ต้องการรีบูท (ในรูปแบบ HH:MM): " time
        if [[ ! "$time" =~ ^[0-2][0-9]:[0-5][0-9]$ ]]; then
            echo "รูปแบบเวลาที่ป้อนผิดพลาด. ใช้ HH:MM."
            exit 1
        fi
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
