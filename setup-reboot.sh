#!/bin/bash

# ตรวจสอบว่าสคริปต์ถูกรันด้วยสิทธิ์ root
if [ "$(id -u)" -ne 0 ]; then
    echo "กรุณารันสคริปต์นี้ด้วยสิทธิ์ root (sudo)"
    exit 1
fi

echo "=== ตั้งค่ารีบูต VPS อัตโนมัติ ==="
echo "เลือกความถี่ที่ต้องการ:"
echo "1) ทุกวันตอนตี 2"
echo "2) ทุก 3 วันตอนตี 2"
echo "3) ทุก 5 วันตอนตี 2"
echo "4) ทุก 7 วันตอนตี 2"
echo "5) ทุก 1 เดือนตอนตี 2"
echo "6) ตั้งค่าตามเวลาที่ต้องการเอง"
echo "--------------------------------"
read -p "กรุณาเลือกหมายเลข [1-6]: " choice

# ตั้งค่าตามตัวเลือก
case $choice in
    1)
        cron_time="0 2 * * *"
        ;;
    2)
        cron_time="0 2 */3 * *"
        ;;
    3)
        cron_time="0 2 */5 * *"
        ;;
    4)
        cron_time="0 2 */7 * *"
        ;;
    5)
        cron_time="0 2 1 * *"
        ;;
    6)
        read -p "กรุณากรอกนาที (0-59): " minute
        read -p "กรุณากรอกชั่วโมง (0-23): " hour
        read -p "กรุณากรอกวันในเดือน (1-31, ใส่ * ถ้าต้องการทุกวัน): " day
        read -p "กรุณากรอกเดือน (1-12, ใส่ * ถ้าต้องการทุกเดือน): " month
        read -p "กรุณากรอกวันในสัปดาห์ (0-7, ใส่ * ถ้าต้องการทุกวัน): " weekday
        cron_time="$minute $hour $day $month $weekday"
        ;;
    *)
        echo "ตัวเลือกไม่ถูกต้อง! กรุณารันสคริปต์ใหม่"
        exit 1
        ;;
esac

# เพิ่มงานใน crontab
echo "กำลังตั้งค่า Cron..."
(crontab -l 2>/dev/null; echo "$cron_time /sbin/reboot") | crontab -

# แสดงผล Cron jobs ที่ตั้งค่า
echo "ตั้งค่าเรียบร้อยแล้ว! ตรวจสอบ Cron jobs ที่ตั้งไว้:"
crontab -l