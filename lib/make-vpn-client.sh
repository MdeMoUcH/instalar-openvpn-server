#!/bin/bash
 
# Generate OpenVPN clients configuration files.

if [ "$EUID" -ne 0 ]
	then echo "Tienes que ser superusuario..."
	exit
fi
 
CLIENT_NAME=$1
OPENVPN_SERVER="192.168.1.100"
CA_DIR=/etc/openvpn/openvpn-ca
CLIENT_DIR=/etc/openvpn/clients

echo ${CLIENT_NAME} > ${CLIENT_DIR}/${CLIENT_NAME}.txt
read -p "Escribe una contraseña para ${CLIENT_NAME}: " userpassuno
read -p "- Repite la contraseña para ${CLIENT_NAME}: " userpassdos
if [ "$userpassuno" = "$userpassdos" ]; then
	echo ${CLIENT_NAME} > ${CLIENT_DIR}/${CLIENT_NAME}.txt
	echo $userpassuno >> ${CLIENT_DIR}/${CLIENT_NAME}.txt
else
	echo "ERROR: No son iguales.."
	exit
fi

 
cd ${CA_DIR}
source vars
./build-key ${CLIENT_NAME}
 
echo "client
dev tun
proto udp
remote ${OPENVPN_SERVER} 1194
auth-user-pass ${CLIENT_DIR}/${CLIENT_NAME}.txt
user nobody
group nogroup
persist-key
persist-tun
cipher AES-128-CBC
auth SHA256
key-direction 1
remote-cert-tls server
comp-lzo
verb 3" > ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
 
cat <(echo -e '<ca>') \
    ${CA_DIR}/keys/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${CA_DIR}/keys/${CLIENT_NAME}.crt \
    <(echo -e '</cert>\n<key>') \
    ${CA_DIR}/keys/${CLIENT_NAME}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${CA_DIR}/keys/ta.key \
    <(echo -e '</tls-auth>') \
    >> ${CLIENT_DIR}/${CLIENT_NAME}.ovpn
 
echo -e "Client File Created - ${CLIENT_DIR}/${CLIENT_NAME}.ovpn"
