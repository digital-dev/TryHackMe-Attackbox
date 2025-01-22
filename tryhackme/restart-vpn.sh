#!/bin/bash

# Path to the OpenVPN configuration file
OVPN_FILE="/root/tryhackme/connect.ovpn"
URL="http://10.10.10.10/whoami"

# Continuously check if the VPN is working
while true; do
    # Check if the VPN is working by querying the URL
    if ! curl -s --head "$URL" | head -n 1 | grep "HTTP/1.1 200" > /dev/null; then
        echo "VPN connection failed. Restarting VPN..."
        # Kill any existing OpenVPN connections
        killall openvpn
        # Start OpenVPN with the .ovpn file in the background
        sudo openvpn --config "$OVPN_FILE" &
    else
        echo "VPN Connection is up!"
    fi

    # Wait for 60 seconds before checking again
    sleep 10
done