#!/bin/bash

function count_online_users() {
    # นับจำนวนการเชื่อมต่อ SSH ที่ใช้งานอยู่
    ssh_online=$(ps aux | grep sshd | grep -v root | grep priv | wc -l)

    # นับจำนวนการเชื่อมต่อ OpenVPN ที่ใช้งานอยู่ (ถ้ามี)
    if [[ -e /etc/openvpn/openvpn-status.log ]]; then
        openvpn_online=$(grep -c "10.8" /etc/openvpn/openvpn-status.log)
    else
        openvpn_online=0
    fi

    # นับจำนวนการเชื่อมต่อ Dropbear ที่ใช้งานอยู่ (ถ้ามี)
    if [[ -e /etc/default/dropbear ]]; then
        dropbear_online=$(ps aux | grep dropbear | grep -v grep | wc -l)
        dropbear_online=$((dropbear_online - 1))  # ลบกระบวนการ dropbear ตัวเองออก
    else
        dropbear_online=0
    fi

    # รวมจำนวนการเชื่อมต่อทั้งหมด
    total_online=$((ssh_online + openvpn_online + dropbear_online))

    # แสดงผล
    echo "จำนวนผู้ใช้ออนไลน์ทั้งหมด: $total_online"
}

# เรียกใช้งานฟังก์ชัน
count_online_users
