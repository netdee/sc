IP=$(wget -qO- ipv4.icanhazip.com)
echo -e ""
echo -e "**************************************"
echo -e "       เธเธณเธซเธเธ”เธเธฒเธฃเน€เธเธทเนเธญเธกเธ•เนเธญเธเธญเธเน€เธเธดเธฃเนเธเน€เธงเธญเธฃเน "โ€
echo -e ""
echo -e "     [1]  30 เน€เธเธฃเธทเนเธญเธ"
echo -e "     [2]  126 เน€เธเธฃเธทเนเธญเธ"
echo -e "     [3]  252 เน€เธเธฃเธทเนเธญเธ"
echo -e "     [4]  510 เน€เธเธฃเธทเนเธญเธ"
echo -e "     [5]  1020 เน€เธเธฃเธทเนเธญเธ"
echo -e "     [6]  เนเธกเนเธเธณเธเธฑเธ”เน€เธเธฃเธทเนเธญเธ"
echo -e "     [x]  EXIT "
echo -e "**************************************"
echo -e ""
read -p "    เนเธเธฃเธ”เน€เธฅเธทเธญเธเธญเธญเธเธเธฑเนเธเธ—เธตเนเธ•เนเธญเธเธฒเธฃ [1-6 เธซเธฃเธทเธญ x ] :  " mask
echo -e ""
case $mask in
01 | 1 )
cat > /etc/openvpn/server.conf <<-END
port 443
proto tcp
dev tun
sndbuf 0
rcvbuf 0
ca ca.pem
cert server-cert.pem
key server-key.pem
dh dh.pem
#tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.224
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
float
cipher none
comp-lzo yes
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
management $IP 5555
verb 3
#crl-verify crl.pem
client-to-client
client-cert-not-required
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
duplicate-cn
END
/etc/init.d/openvpn restart
clear
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ   โญ เธ”เธณเน€เธเธดเธเธเธฒเธฃเธชเธณเน€เธฃเนเธ โญ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ เธเธฑเธเธเธธเธเธฑเธเน€เธเธทเนเธญเธกเธ•เนเธญเนเธ”เน 30 เน€เธเธฃเธทเนเธญเธ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
;;

02 | 2 )
cat > /etc/openvpn/server.conf <<-END
port 443
proto tcp
dev tun
sndbuf 0
rcvbuf 0
ca ca.pem
cert server-cert.pem
key server-key.pem
dh dh.pem
#tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.128
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
float
cipher none
comp-lzo yes
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
management $IP 5555
verb 3
#crl-verify crl.pem
client-to-client
client-cert-not-required
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
duplicate-cn
END
/etc/init.d/openvpn restart
clear
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ   โญ เธ”เธณเน€เธเธดเธเธเธฒเธฃเธชเธณเน€เธฃเนเธ โญ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ เธเธฑเธเธเธธเธเธฑเธเน€เธเธทเนเธญเธกเธ•เนเธญเนเธ”เน 126 เน€เธเธฃเธทเนเธญเธ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
;;

03 | 3 )
cat > /etc/openvpn/server.conf <<-END
port 443
proto tcp
dev tun
sndbuf 0
rcvbuf 0
ca ca.pem
cert server-cert.pem
key server-key.pem
dh dh.pem
#tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
float
cipher none
comp-lzo yes
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
management $IP 5555
verb 3
#crl-verify crl.pem
client-to-client
client-cert-not-required
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
duplicate-cn
END
/etc/init.d/openvpn restart
clear
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ   โญ เธ”เธณเน€เธเธดเธเธเธฒเธฃเธชเธณเน€เธฃเนเธ โญ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ เธเธฑเธเธเธธเธเธฑเธเน€เธเธทเนเธญเธกเธ•เนเธญเนเธ”เน 252 เน€เธเธฃเธทเนเธญเธ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
;;

04 | 4 )
cat > /etc/openvpn/server.conf <<-END
port 443
proto tcp
dev tun
sndbuf 0
rcvbuf 0
ca ca.pem
cert server-cert.pem
key server-key.pem
dh dh.pem
#tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.254.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
float
cipher none
comp-lzo yes
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
management $IP 5555
verb 3
#crl-verify crl.pem
client-to-client
client-cert-not-required
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
duplicate-cn
END
/etc/init.d/openvpn restart
clear
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ   โญ เธ”เธณเน€เธเธดเธเธเธฒเธฃเธชเธณเน€เธฃเนเธ โญ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ เธเธฑเธเธเธธเธเธฑเธเน€เธเธทเนเธญเธกเธ•เนเธญเนเธ”เน 510 เน€เธเธฃเธทเนเธญเธ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
;;

05 | 5 )
cat > /etc/openvpn/server.conf <<-END
port 443
proto tcp
dev tun
sndbuf 0
rcvbuf 0
ca ca.pem
cert server-cert.pem
key server-key.pem
dh dh.pem
#tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.252.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
float
cipher none
comp-lzo yes
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
management $IP 5555
verb 3
#crl-verify crl.pem
client-to-client
client-cert-not-required
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
duplicate-cn
END
/etc/init.d/openvpn restart
clear
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ   โญ เธ”เธณเน€เธเธดเธเธเธฒเธฃเธชเธณเน€เธฃเนเธ โญ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ เธเธฑเธเธเธธเธเธฑเธเน€เธเธทเนเธญเธกเธ•เนเธญเนเธ”เน 1020 เน€เธเธฃเธทเนเธญเธ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
;;

06 | 6 )
cat > /etc/openvpn/server.conf <<-END
port 443
proto tcp
dev tun
sndbuf 0
rcvbuf 0
ca ca.pem
cert server-cert.pem
key server-key.pem
dh dh.pem
#tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.0.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
float
cipher none
comp-lzo yes
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
management $IP 5555
verb 3
#crl-verify crl.pem
client-to-client
client-cert-not-required
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
duplicate-cn
END
/etc/init.d/openvpn restart
clear
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ   โญ เธ”เธณเน€เธเธดเธเธเธฒเธฃเธชเธณเน€เธฃเนเธ โญ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”ณโ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
echo "    โ•ญโ”โ”โ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”ปโ”โ”โ”โ”โ”โ”โ”โ”โ•ฎ "
echo "    โ”ฃ เธเธฑเธเธเธธเธเธฑเธเน€เธเธทเนเธญเธกเธ•เนเธญเนเธกเนเธเธณเธเธฑเธ”เน€เธเธฃเธทเนเธญเธ "
echo "    โ•ฐโ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ”โ•ฏ "
;;

x)
clear
menu
;;
*)
echo "เนเธเธฃเธ”เนเธชเนเธเธณเธชเธฑเนเธเนเธซเนเธ–เธนเธเธ•เนเธญเธ"
;;
esac
