#!/bin/bash

# URLs ของไฟล์ที่ต้องการดาวน์โหลด
CONFIG_URL="https://raw.githubusercontent.com/netdee/sc/refs/heads/main/fixopenvpn/server.conf"
SCRIPT_URL="https://raw.githubusercontent.com/netdee/sc/refs/heads/main/fixopenvpn/open.py"

# ตำแหน่งที่ตั้งของไฟล์ในเซิร์ฟเวอร์
CONFIG_FILE="/etc/openvpn/server.conf"
SCRIPT_FILE="/etc/TH-VPN/open.py"

# ฟังก์ชันสำหรับสำรองและแทนที่ไฟล์
download_and_replace() {
    local url="$1"
    local destination="$2"

    # สำรองไฟล์เดิมถ้ามีอยู่
    if [ -f "$destination" ]; then
        cp "$destination" "${destination}.backup"
        echo "Backup created at ${destination}.backup"
    else
        echo "No existing file found at ${destination}. Proceeding without backup."
    fi

    # ดาวน์โหลดไฟล์ใหม่และแทนที่ไฟล์เดิม
    echo "Downloading new file from ${url} to ${destination}..."
    curl -o "$destination" "$url"

    # ตรวจสอบว่าการดาวน์โหลดสำเร็จหรือไม่
    if [ $? -eq 0 ]; then
        echo "File at ${destination} has been updated successfully."
    else
        echo "Failed to download the file from ${url}."
        # คืนค่าจากไฟล์สำรองถ้าการดาวน์โหลดล้มเหลว
        if [ -f "${destination}.backup" ]; then
            mv "${destination}.backup" "$destination"
            echo "The original file has been restored from backup at ${destination}."
        fi
        exit 1
    fi
}

# เรียกใช้งานฟังก์ชันสำหรับแต่ละไฟล์
download_and_replace "$CONFIG_URL" "$CONFIG_FILE"
download_and_replace "$SCRIPT_URL" "$SCRIPT_FILE"

# รีสตาร์ทบริการที่ต้องการ
echo "Restarting SSH, OpenVPN, and SSL services..."
systemctl restart ssh
systemctl restart openvpn
systemctl restart stunnel4  # SSL service (assuming stunnel4 is used for SSL)
echo "Services have been restarted successfully."
