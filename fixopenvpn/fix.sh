#!/bin/bash

# URLs ของไฟล์ที่ต้องการดาวน์โหลด
CONFIG_URL="https://raw.githubusercontent.com/netdee/sc/refs/heads/main/fixopenvpn/server.conf"
SCRIPT_URL="https://raw.githubusercontent.com/netdee/sc/refs/heads/main/fixopenvpn/open.py"

# ตำแหน่งที่ตั้งของไฟล์ในเซิร์ฟเวอร์
CONFIG_FILE="/etc/openvpn/server.conf"
SCRIPT_FILE="/etc/TH-VPN/open.py"
APACHE_PORTS_CONF="/etc/apache2/ports.conf"

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

# แก้ไขพอร์ตในไฟล์ /etc/apache2/ports.conf
update_apache_port() {
    echo "Updating Apache ports.conf to listen on port 82..."
    
    # สำรองไฟล์เดิม
    if [ -f "$APACHE_PORTS_CONF" ]; then
        cp "$APACHE_PORTS_CONF" "${APACHE_PORTS_CONF}.backup"
        echo "Backup created at ${APACHE_PORTS_CONF}.backup"
    else
        echo "No existing Apache configuration found. Proceeding without backup."
    fi

    # แก้ไขพอร์ตในไฟล์ /etc/apache2/ports.conf
    sed -i 's/^Listen .*/Listen 82/' "$APACHE_PORTS_CONF"
    
    # ตรวจสอบว่าการแก้ไขสำเร็จหรือไม่
    if [ $? -eq 0 ]; then
        echo "Apache port updated to 82 successfully."
    else
        echo "Failed to update the Apache port."
        # คืนค่าจากไฟล์สำรองถ้าการแก้ไขล้มเหลว
        if [ -f "${APACHE_PORTS_CONF}.backup" ]; then
            mv "${APACHE_PORTS_CONF}.backup" "$APACHE_PORTS_CONF"
            echo "The original Apache configuration has been restored from backup."
        fi
        exit 1
    fi
}

# เรียกใช้งานฟังก์ชันสำหรับแต่ละไฟล์
download_and_replace "$CONFIG_URL" "$CONFIG_FILE"
download_and_replace "$SCRIPT_URL" "$SCRIPT_FILE"

# แก้ไขพอร์ตของ Apache
update_apache_port

# รีสตาร์ทบริการที่ต้องการ
echo "Restarting SSH, OpenVPN, SSL, and Apache services..."
systemctl restart ssh
systemctl restart openvpn
systemctl restart stunnel4  # SSL service (assuming stunnel4 is used for SSL)
systemctl restart apache2   # Restart Apache service to apply the port change

echo "Services have been restarted successfully."
