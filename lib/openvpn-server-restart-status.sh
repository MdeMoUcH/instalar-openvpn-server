#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "Tienes que ser superusuario..."
	exit
fi

sudo systemctl stop openvpn@server
sudo systemctl start openvpn@server
sudo systemctl status openvpn@server
echo ""
ifconfig tun0
