#!/bin/bash
clear

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
CORTITLE='\033[1;41m'
DIR='/etc/DARKssh/dns'
SCOLOR='\033[0m'

configdns() {
    interface=$(ip a | awk '/state UP/{print $2}' | cut -d: -f1)
    iptables -F >/dev/null 2>&1
    iptables -I INPUT -p udp --dport 5300 -j ACCEPT
    iptables -t nat -I PREROUTING -i $interface -p udp --dport 53 -j REDIRECT --to-ports 5300
    ip6tables -I INPUT -p udp --dport 5300 -j ACCEPT
    ip6tables -t nat -I PREROUTING -i $interface -p udp --dport 53 -j REDIRECT --to-ports 5300
}

echo -e "${CORTITLE}           DARKSSH SLOWDNS (Beta)            ${SCOLOR}"
installslowdns() {
    echo -e "\n${YELLOW}BE AWARE THAT THIS METHOD IS STILL IN THE BETA PHASE AND THAT BEYOND BEING SLOW IT MAY NOT WORK PERFECTLY ! ${SCOLOR}\n"
    echo -ne "${GREEN}DO YOU WANT TO CONTINUE THE INSTALLATION? ${YELLOW}[s/n]:${SCOLOR} "
    read resp
    [[ "$resp" != @(s|sim|S|SIM) ]] && {
        echo -e "\n${RED}Returning...${SCOLOR}"
        sleep 2
        conexao
    }
    mkdir /etc/DARKssh/dns >/dev/null 2>&1
    wget -P $DIR https://github.com/sbatrow/DARKSSH-MANAGER/raw/main/Modulos/dns-server >/dev/null 2>&1
    chmod 777 $DIR/dns-server >/dev/null 2>&1
    $DIR/dns-server -gen-key -privkey-file $DIR/server.key -pubkey-file $DIR/server.pub >/dev/null 2>&1
    configdns >/dev/null 2>&1
    cat /dev/null >~/.bash_history && history -c
}
initslow() {
    [[ $(ss -lu | grep -wc '5300') != '0' ]] && {
        echo -e "\n${RED}[${CYAN}1${RED}] ${YELLOW}PARAR O SLOWDNS${SCOLOR}"
        echo -e "${RED}[${CYAN}2${RED}] ${YELLOW}REMOVER O SLOWDNS${SCOLOR}"
        echo -e "${RED}[${CYAN}3${RED}] ${YELLOW}EXIBIR INFORMACOES${SCOLOR}"
        echo -e "${RED}[${CYAN}0${RED}] ${YELLOW}VOLTAR${SCOLOR}"
        echo -ne "\n${GREEN}REPORT AN OPTION${SCOLOR}: "
        read op
        if [[ "$op" == '1' ]]; then
            screen -r -S "slow_dns" -X quit >/dev/null 2>&1
            screen -wipe >/dev/null 2>&1
            sed -i '/5300/d' /etc/autostart >/dev/null 2>&1
            sed -i '/slow_dns/d' /etc/DARKssh/dns/autodns >/dev/null 2>&1
            echo -e "\n${RED}SLOWDNS DISABLED !${SCOLOR}"
            sleep 2
            conexao
        elif [[ "$op" == '2' ]]; then
            screen -r -S "slow_dns" -X quit >/dev/null 2>&1
            screen -wipe >/dev/null 2>&1
            sed -i '/5300/d' /etc/autostart >/dev/null 2>&1
            rm -rf /etc/DARKssh/dns >/dev/null 2>&1
            echo -e "\n${RED}SLOWDNS REMOVED !${SCOLOR}"
            sleep 2
            conexao
        elif [[ "$op" == '3' ]]; then
            [[ -e $DIR/server.pub ]] && keypub=$(cat $DIR/server.pub) || keypub='Null'
            [[ -e $DIR/autodns ]] && nameserver=$(grep -w 'server.key' /etc/DARKssh/dns/autodns | awk -F' ' '{print $9}') || nameserver='Null'
            tmx='curl -sO https://github.com/sbatrow/DARKSSH-MANAGER/raw/main/Modulos/slowdns && chmod +x slowdns && ./slowdns'
            clear
            echo -e "${CORTITLE}           DARKSSH SLOWDNS (Beta)            ${SCOLOR}"
            echo -e "\n${YELLOW}NAMESERVER(NS)${SCOLOR}: $nameserver"
            echo -e "${YELLOW}CHAVE PUBLICA${SCOLOR}: $keypub"
            echo -e "\n${GREEN}COMANDO TERMUX${SCOLOR}: ${tmx} ${nameserver} ${keypub}"
            echo -ne "\n${RED}ENTER${YELLOW} to return to${GREEN} MENU!${SCOLOR}"
            read
            conexao
        elif [[ "$op" == '0' ]]; then
            sleep 1
            conexao
        else
            echo -e "\n${RED}INVALID OPTION${SCOLOR}"
            sleep 1.5
            conexao
        fi
    } || {
        clear
        echo -e "${CORTITLE}           DARKSSH SLOWDNS (Beta)            ${SCOLOR}"
        echo -ne "\n${GREEN}INFORM THE NS DOMAIN${SCOLOR}: "
        read ns
        [[ -z "$ns" ]] && {
            echo -e "\n${RED}INVALID DOMAIN${SCOLOR}"
            sleep 1.5
            initslow
        }
        echo -e "\n${RED}[${CYAN}1${RED}] ${YELLOW}SLOWDNS SSH${SCOLOR}"
        echo -e "${RED}[${CYAN}2${RED}] ${YELLOW}SLOWDNS SSL${SCOLOR}"
        echo -e "${RED}[${CYAN}3${RED}] ${YELLOW}SLOWDNS SSLH${SCOLOR}"
        echo -e "${RED}[${CYAN}4${RED}] ${YELLOW}SLOWDNS OPENVPN${SCOLOR}"
        echo -e "${RED}[${CYAN}0${RED}] ${YELLOW}VOLTAR${SCOLOR}"
        echo -ne "\n${GREEN}REPORT AN OPTION${SCOLOR}: "
        read opcc
        if [[ "$opcc" == '1' ]]; then
            ptdns='22'
        elif [[ "$opcc" == '2' ]]; then
            ptdns=$(netstat -nplt | grep 'stunnel' | awk {'print $4'} | cut -d: -f2)
            [[ $ptdns == '' ]] && {
                echo -e "\n${RED}FIRST INSTALL SSL TUNNEL !${SCOLOR}"
                sleep 1.5
                initslow
            }
        elif [[ "$opcc" == '3' ]]; then
            ptdns=$(netstat -nplt | grep 'sslh' | awk {'print $4'} | cut -d: -f2)
            [[ $ptdns == '' ]] && {
                echo -e "\n${RED}FIRST INSTALL SSLH !${SCOLOR}"
                sleep 1.5
                initslow
            }
        elif [[ "$opcc" == '4' ]]; then
            [[ ! -e /etc/openvpn/server.conf ]] && {
                echo -e "\n${RED}FIRST INSTALL OPENVPN !${SCOLOR}"
                sleep 1.5
                initslow
            } || {
                ptdns=$(sed -n 1p /etc/openvpn/server.conf| cut -d' ' -f2)
            }
        elif [[ "$opcc" == '0' ]]; then
            sleep 1.5
            conexao
        else
            echo -e "\n${RED}INVALID OPTION${SCOLOR}"
            sleep 1.5
            initslow
        fi
        screen -dmS slow_dns $DIR/dns-server -udp :5300 -privkey-file $DIR/server.key ${ns} 0.0.0.0:${ptdns} >/dev/null 2>&1
        keypub=$(cat $DIR/server.pub)
        cd $HOME
        echo -e "\n${YELLOW}SLOWDNS ON...${SCOLOR}"
        [[ ! -e /etc/iptables/rules.v4 ]] && {
            configdns > /dev/null 2>&1
            DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent >/dev/null 2>&1
        } || {
            sleep 2
            configdns > /dev/null 2>&1
            iptables-save > /etc/iptables/rules.v4
        }
        echo "screen -dmS slow_dns $DIR/dns-server -udp :5300 -privkey-file $DIR/server.key ${ns} 0.0.0.0:${ptdns}" >/etc/DARKssh/dns/autodns
        chmod 777 /etc/DARKssh/dns/autodns >/dev/null 2>&1
        echo "ss -lu|grep -w '5300' || /etc/DARKssh/dns/autodns" >>/etc/autostart
        tmx='curl -sO  https://github.com/sbatrow/DARKSSH-MANAGER/raw/main/Modulos/slowdns && chmod +x slowdns && ./slowdns'
        echo -e "\n${GREEN}SLOWDNS ON !${SCOLOR}"
        echo -e "\n${YELLOW}TERMUX COMMAND${SCOLOR}: ${tmx} ${ns} ${keypub}"
        echo -ne "\n${RED}ENTER${YELLOW} to return to${GREEN} MENU!${SCOLOR}"
        read
        conexao
    }
}
[[ -d $DIR ]] && {
    initslow
} || {
    installslowdns
    sleep 0.5
    initslow
}
