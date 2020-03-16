#!/bin/bash

#Script para instalar una vpn.

#https://tecadmin.net/install-openvpn-server-ubuntu/


sudo apt-get update
sudo apt-get upgrade
sudo apt install openvpn easy-rsa


ruta=`pwd`

gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf


nano /etc/openvpn/server.conf


echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sudo sysctl -p


sudo modprobe iptable_nat
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE


make-cadir /etc/openvpn/openvpn-ca/
cd /etc/openvpn/openvpn-ca/


nano vars

source vars

./clean-all
./build-ca


cd /etc/openvpn/openvpn-ca/
./build-key-server server

openssl dhparam -out /etc/openvpn/dh2048.pem 2048

openvpn --genkey --secret /etc/openvpn/openvpn-ca/keys/ta.key


cd /etc/openvpn/openvpn-ca/keys
sudo cp ca.crt ta.key server.crt server.key /etc/openvpn


sudo systemctl start openvpn@server


#sudo systemctl status openvpn@server #Para ver el estado
#ifconfig tun0 #Para ver la nueva interfaz de red en 


mkdir /etc/openvpn/clients

cd $ruta cp make-vpn-client.sh /etc/openvpn/clients/

cd /etc/openvpn/clients

chmod +x ./make-vpn-client.sh

./make-vpn-client.sh vpnclient1








