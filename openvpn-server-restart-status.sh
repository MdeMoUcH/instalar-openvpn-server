#!/bin/bash

sudo systemctl start openvpn@server
sudo systemctl status openvpn@server
ifconfig tun0
