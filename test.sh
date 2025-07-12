#!/bin/bash
fun_online() {
    _ons=$(ps -x | grep sshd | grep -v root | grep priv | wc -l)
    
    _onop=0
    if [[ -e /etc/openvpn/openvpn-status.log ]]; then
        _onop=$(grep -c "10.8.0" /etc/openvpn/openvpn-status.log)
    fi

    _ondrp=0
    if [[ -e /etc/default/dropbear ]]; then
        _ondrp=$(ps aux | grep dropbear | grep -v grep | wc -l)
    fi

    _onli=$(($_ons + $_onop + $_ondrp))
    _onlin=$(printf '%-5s' "$_onli")
    _quantity=200

    CURRENT_ONLINES="$(echo -e "${_onlin}" | sed -e 's/[[:space:]]*$//')"

    # เขียนไฟล์ JSON ให้ถูกต้อง
    echo "[{\"onlines\":${CURRENT_ONLINES},\"limite\":${_quantity}}]" > /var/www/html/server/online_app.json
    
    echo $CURRENT_ONLINES > /var/www/html/server/online
    echo $CURRENT_ONLINES > /var/www/html/server/online.json
}

while true; do
    echo 'กำลังตรวจสอบ...'
    fun_online > /dev/null 2>&1
    sleep 15s
done
