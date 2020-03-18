#!/bin/bash

sudo systemctl stop openvpn@server
sudo systemctl start openvpn@server
sudo systemctl status openvpn@server
ifconfig tun0
