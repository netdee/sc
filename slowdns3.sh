#!/bin/bash
clear

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
CORTITLE='\033[1;41m'
DIR='/etc/DARKssh/dns'
SCOLOR='\033[0m'

keypub='ab4bb2c990429b57ef33d0936ff72384ad0d414c6c0f38223abd11c74d11866b'

configdns() {
    interface=$(ip a | awk '/state UP/{print $2}' | cut -d: -f1)
    iptables -F >/dev/null 2>&1
    iptables -I INPUT -p udp --dport 5300 -j ACCEPT
    iptables -t nat -I PREROUTING -i $interface -p udp --dport 53 -j REDIRECT --to-ports 5300
    ip6tables -I INPUT -p udp --dport 5300 -j ACCEPT
    ip6tables -t nat -I PREROUTING -i $interface -p udp --dport 53 -j REDIRECT --to-ports 5300
}

installslowdns() {
    echo -e "\n${YELLOW}โปรดทราบว่าวิธีนี้ยังอยู่ในช่วงทดสอบและอาจไม่ทำงานสมบูรณ์!${SCOLOR}\n"
    echo -ne "${GREEN}คุณต้องการติดตั้งต่อหรือไม่? ${YELLOW}[s/n]:${SCOLOR} "
    read resp
    [[ "$resp" != @(s|sim|S|SIM) ]] && {
        echo -e "\n${RED}กำลังกลับ...${SCOLOR}"
        sleep 2
        dnstt
    }
    mkdir /etc/DARKssh/dns >/dev/null 2>&1
    wget -P $DIR https://github.com/sbatrow/DARKSSH-MANAGER/raw/main/Modulos/dns-server >/dev/null 2>&1
    chmod 777 $DIR/dns-server >/dev/null 2>&1
    $DIR/dns-server -gen-key -privkey-file $DIR/server.key -pubkey-file $DIR/server.pub >/dev/null 2>&1
    configdns >/dev/null 2>&1
    cat /dev/null >~/.bash_history && history -c
}

startslowdns() {
    clear
    echo -e "${CORTITLE}           DARKSSH SLOWDNS (Beta)            ${SCOLOR}"
    echo -ne "\n${GREEN}กรุณาระบุชื่อโดเมน NS:${SCOLOR} "
    read ns
    [[ -z "$ns" ]] && {
        echo -e "\n${RED}โดเมนไม่ถูกต้อง${SCOLOR}"
        sleep 1.5
        startslowdns
    }
    echo -e "\n${RED}[${CYAN}1${RED}] ${YELLOW}SlowDNS SSH${SCOLOR}"
    echo -e "${RED}[${CYAN}2${RED}] ${YELLOW}SlowDNS SSL${SCOLOR}"
    echo -e "${RED}[${CYAN}3${RED}] ${YELLOW}SlowDNS SSLH${SCOLOR}"
    echo -e "${RED}[${CYAN}4${RED}] ${YELLOW}SlowDNS OpenVPN${SCOLOR}"
    echo -e "${RED}[${CYAN}0${RED}] ${YELLOW}กลับ${SCOLOR}"
    echo -ne "\n${GREEN}กรุณาเลือกตัวเลือก:${SCOLOR} "
    read opcc

    case "$opcc" in
        1) ptdns='22' ;;
        2)
            ptdns=$(netstat -nplt | grep 'stunnel' | awk '{print $4}' | cut -d: -f2)
            [[ -z "$ptdns" ]] && {
                echo -e "\n${RED}กรุณาติดตั้ง SSL Tunnel ก่อน!${SCOLOR}"
                sleep 1.5
                startslowdns
            }
            ;;
        3)
            ptdns=$(netstat -nplt | grep 'sslh' | awk '{print $4}' | cut -d: -f2)
            [[ -z "$ptdns" ]] && {
                echo -e "\n${RED}กรุณาติดตั้ง SSLH ก่อน!${SCOLOR}"
                sleep 1.5
                startslowdns
            }
            ;;
        4)
            [[ ! -e /etc/openvpn/server.conf ]] && {
                echo -e "\n${RED}กรุณาติดตั้ง OpenVPN ก่อน!${SCOLOR}"
                sleep 1.5
                startslowdns
            } || {
                ptdns=$(sed -n 1p /etc/openvpn/server.conf | cut -d' ' -f2)
            }
            ;;
        0)
            sleep 1.5
            dnstt
            ;;
        *)
            echo -e "\n${RED}ตัวเลือกไม่ถูกต้อง${SCOLOR}"
            sleep 1.5
            startslowdns
            ;;
    esac

    screen -dmS slow_dns $DIR/dns-server -udp :5300 -privkey-file $DIR/server.key ${ns} 0.0.0.0:${ptdns} >/dev/null 2>&1
    cd $HOME
    echo -e "\n${YELLOW}SlowDNS เปิดใช้งานแล้ว...${SCOLOR}"

    if [[ ! -e /etc/iptables/rules.v4 ]]; then
        configdns
        DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent >/dev/null 2>&1
    else
        sleep 2
        configdns
        iptables-save > /etc/iptables/rules.v4
    fi

    echo "screen -dmS slow_dns $DIR/dns-server -udp :5300 -privkey-file $DIR/server.key ${ns} 0.0.0.0:${ptdns}" >/etc/DARKssh/dns/autodns
    chmod 777 /etc/DARKssh/dns/autodns >/dev/null 2>&1
    echo "ss -lu|grep -w '5300' || /etc/DARKssh/dns/autodns" >>/etc/autostart
    tmx='curl -sO https://github.com/sbatrow/DARKSSH-MANAGER/raw/main/Modulos/slowdns && chmod +x slowdns && ./slowdns'
    echo -e "\n${GREEN}SlowDNS เปิดใช้งานแล้ว!${SCOLOR}"
    echo -e "\n${YELLOW}คำสั่งสำหรับ Termux:${SCOLOR} ${tmx} ${ns} ${keypub}"
    echo -ne "\n${RED}ENTER${YELLOW} เพื่อกลับไปยัง${GREEN} เมนู!${SCOLOR}"
    read
    dnstt
}

stopslowdns() {
    screen -r -S "slow_dns" -X quit >/dev/null 2>&1
    screen -wipe >/dev/null 2>&1
    sed -i '/5300/d' /etc/autostart >/dev/null 2>&1
    sed -i '/slow_dns/d' /etc/DARKssh/dns/autodns >/dev/null 2>&1
    echo -e "\n${RED}SlowDNS ถูกปิดใช้งานแล้ว!${SCOLOR}"
    sleep 2
    dnstt
}

removeslowdns() {
    stopslowdns
    rm -rf /etc/DARKssh/dns >/dev/null 2>&1
    echo -e "\n${RED}SlowDNS ถูกลบแล้ว!${SCOLOR}"
    sleep 2
    dnstt
}

showinfo() {
    [[ -e $DIR/autodns ]] && nameserver=$(grep -w 'server.key' /etc/DARKssh/dns/autodns | awk -F' ' '{print $9}') || nameserver='Null'
    tmx='curl -sO https://github.com/sbatrow/DARKSSH-MANAGER/raw/main/Modulos/slowdns && chmod +x slowdns && ./slowdns'
    clear
    echo -e "${CORTITLE}           DARKSSH SLOWDNS (Beta)            ${SCOLOR}"
    echo -e "\n${YELLOW}NAMESERVER(NS)${SCOLOR}: $nameserver"
    echo -e "${YELLOW}CHAVE PUBLICA${SCOLOR}: $keypub"
    echo -e "\n${GREEN}คำสั่งสำหรับ Termux${SCOLOR}: ${tmx} ${nameserver} ${keypub}"
    echo -ne "\n${RED}ENTER${YELLOW} เพื่อกลับไปยัง${GREEN} เมนู!${SCOLOR}"
    read
    dnstt
}

dnstt() {
    while true; do
        clear
        echo -e "${CORTITLE}           DARKSSH SLOWDNS (Beta)            ${SCOLOR}"
        echo -e "\n${GREEN}เลือกตัวเลือกที่ต้องการ:${SCOLOR}"
        echo -e "${RED}[${CYAN}1${RED}] ${YELLOW}ติดตั้ง SlowDNS${SCOLOR}"
        echo -e "${RED}[${CYAN}2${RED}] ${YELLOW}เริ่มต้น SlowDNS${SCOLOR}"
        echo -e "${RED}[${CYAN}3${RED}] ${YELLOW}หยุด SlowDNS${SCOLOR}"
        echo -e "${RED}[${CYAN}4${RED}] ${YELLOW}ลบ SlowDNS${SCOLOR}"
        echo -e "${RED}[${CYAN}5${RED}] ${YELLOW}แสดงข้อมูล SlowDNS${SCOLOR}"
        echo -e "${RED}[${CYAN}0${RED}] ${YELLOW}ออก${SCOLOR}"
        echo -ne "\n${GREEN}กรุณาเลือกตัวเลือก:${SCOLOR} "
        read opt
        case $opt in
            1) installslowdns ;;
            2) startslowdns ;;
            3) stopslowdns ;;
            4) removeslowdns ;;
            5) showinfo ;;
            0) exit 0 ;;
            *) echo -e "\n${RED}เลือกตัวเลือกไม่ถูกต้อง${SCOLOR}"; sleep 1 ;;
        esac
    done
}

dnstt
