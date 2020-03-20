#!/bin/bash

#Script para instalar una vpn.

#https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-18-04
#Step 6

if [ "$EUID" -ne 0 ]
  then echo "Tienes que ser superusuario..."
  exit
fi

echo ""
echo "Descomenta la siguiente linea: "
echo "net.ipv4.ip_forward=1"
echo ""
read -p "Pulsa intro para continuar"

sudo nano /etc/sysctl.conf

sudo sysctl -p

ip route | grep default

echo ""
echo "Copia lo siguiente al principio del archivo: "
echo ""
echo "# START OPENVPN RULES"
echo "# NAT table rules"
echo "*nat"
echo ":POSTROUTING ACCEPT [0:0] "
echo "# Allow traffic from OpenVPN client to eth0 (change to the interface you discovered!)"
echo "-A POSTROUTING -s 10.0.0.0/8 -o eth0 -j MASQUERADE"
echo "COMMIT"
echo "# END OPENVPN RULES"
echo ""
read -p "Pulsa intro para continuar"

sudo nano /etc/ufw/before.rules



echo ""
echo "Cambia el DEFAULT_FORWARD_POLICY de DROP a ACCEPT: "
echo "DEFAULT_FORWARD_POLICY=\"ACCEPT\" "
echo ""
read -p "Pulsa intro para continuar"

sudo nano /etc/default/ufw


sudo ufw allow 1194/udp
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw enable





