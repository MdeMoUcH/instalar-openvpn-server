#!/bin/bash

#Script para instalar una vpn.

#https://tecadmin.net/install-openvpn-server-ubuntu/

if [ "$EUID" -ne 0 ]
  then echo "Tienes que ser superusuario..."
  exit
fi


sudo apt-get update
sudo apt-get upgrade
sudo apt install openvpn easy-rsa

dpkg -s openssl


ruta=`pwd`
ruta=$ruta'/extra'

gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf


mv -f /etc/openvpn/server.conf /etc/openvpn/server.bak.conf
cp $ruta'/server.conf' /etc/openvpn/server.conf


echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sudo sysctl -p


sudo modprobe iptable_nat
sudo iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE


make-cadir /etc/openvpn/openvpn-ca/
#chmod 755
cd /etc/openvpn/openvpn-ca/

cp  $ruta'/openssl.cnf' .

cp $ruta'/vars' .

source vars

./clean-all
./build-ca
./build-key-server server

openssl dhparam -out /etc/openvpn/dh2048.pem 2048

openvpn --genkey --secret /etc/openvpn/openvpn-ca/keys/ta.key


cd /etc/openvpn/openvpn-ca/keys
sudo cp ca.crt ta.key server.crt server.key /etc/openvpn


mkdir /etc/openvpn/clients

cd $ruta

cp make-vpn-client.sh /etc/openvpn/clients/

cd /etc/openvpn/clients

chmod +x ./make-vpn-client.sh

echo ""
echo "Ya se ha instalado el servidor OPENVPN"
echo""

read -p "Quieres crear un cliente de prueba? [y/N]: " respuesta
if [ "$respuesta" = "y" ]; then
  ./make-vpn-client.sh test
fi

read -p "Quieres configurar la red? [y/N]: " respuesta
if [ "$respuesta" = "y" ]; then
	cd $ruta
	./configurar-red-openvpn-server.sh
fi

read -p "Quieres iniciar la VPN? [y/N]: " respuesta
if [ "$respuesta" = "y" ]; then
	cd $ruta
	./openvpn-server-restart-status.sh
fi










