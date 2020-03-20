#!/bin/bash

#Script para instalar una vpn.

#https://tecadmin.net/install-openvpn-server-ubuntu/

if [ "$EUID" -ne 0 ]
	then echo "Tienes que ser superusuario..."
	exit
fi

cd /etc/openvpn/clients

./make-vpn-client.sh vpnclient1








