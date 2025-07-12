#!/bin/bash
# รวมการนับผู้ใช้ออนไลน์ (SSH, OpenVPN, Dropbear) และบันทึกลง 4 ไฟล์

function count_online_users() {
    # นับผู้ใช้ SSH
    ssh_online=$(ps aux | grep sshd | grep -v root | grep priv | wc -l)

    # นับผู้ใช้ OpenVPN
    if [[ -e /etc/openvpn/openvpn-status.log ]]; then
        openvpn_online=$(grep -c "10.8" /etc/openvpn/openvpn-status.log)
    else
        openvpn_online=0
    fi

    # นับผู้ใช้ Dropbear
    if [[ -e /etc/default/dropbear ]]; then
        dropbear_online=$(ps aux | grep dropbear | grep -v grep | wc -l)
        dropbear_online=$((dropbear_online - 1))
    else
        dropbear_online=0
    fi

    # รวมทั้งหมด
    total_online=$((ssh_online + openvpn_online + dropbear_online))
    echo "จำนวนผู้ใช้ออนไลน์ทั้งหมด: $total_online"

    # ตรวจสอบว่าโฟลเดอร์ /var/www/html/server มีหรือยัง ถ้ายังไม่มีให้สร้าง
    if [[ ! -d /var/www/html/server ]]; then
        mkdir -p /var/www/html/server
        chown -R $USER:$USER /var/www/html/server
    fi

    # JSON string
    json_output="{\"onlines\":\"$total_online\",\"limite\":\"250\"}"

    # เขียนไฟล์ทั้งหมด
    echo "$json_output" > /var/www/html/server/online_app
    echo "$json_output" > /var/www/html/server/online_app.json
    echo "$total_online" > /var/www/html/server/online
    echo "$total_online" > /var/www/html/server/online.json
}

# วนลูปทำงานตลอด
while true; do
    count_online_users > /dev/null 2>&1
    sleep 15s
done
