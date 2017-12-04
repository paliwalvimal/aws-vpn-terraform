#!/bin/bash
#Let the script wait for 5seconds
sleep 5s
#Accept Agreement
echo "yes"
#Primary server node
echo "yes"
#Network interface
echo ""
#Port number for admin web UI
echo ""
#Port number for OpenVPN Daemon
echo ""
#Route client traffic through VPN
echo "yes"
#Route DNS traffic though VPN
echo "yes"
#Auth via local db
echo ""
#Pvt subnets accessible by clients
echo ""
#Login to admin as "openvpn" user
echo ""
#Licence key
echo ""
#Setting password for user openvpn
echo -e "openvpnpass\nopenvpnpass" | passwd openvpn
