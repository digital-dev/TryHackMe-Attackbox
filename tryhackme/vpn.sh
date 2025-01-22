#!/bin/bash

# Set the URL to check
URL="http://10.10.10.10/whoami"

# Path to the OpenVPN configuration file
OVPN_FILE="/root/tryhackme/connect.ovpn"

# Start the infinite while loop
while true; do
    # Make the curl request and capture the response
    response=$(curl -s $URL)

    # Check if the response is not empty
    if [[ -n "$response" ]]; then
        echo "Received response: $response"
    else
        echo "No response or empty response. Retrying..."

        # If the request fails, run OpenVPN
        echo "Attempting to start VPN..."
        killall openvpn  # Ensure no previous OpenVPN instances are running
        echo "Starting VPN with $OVPN_FILE..."
        sudo openvpn --config "$OVPN_FILE" > /root/openvpn.log 2>&1 &
        # Set MTU to 1200
        current_mtu=$(ip link show tun0 | grep -oP 'mtu \K\d+')

        # Check if the current MTU is 1200
        if [[ "$current_mtu" -ne 1200 ]]; then
            # Set MTU to 1200 if it's not already
            sudo ip link set dev tun0 mtu 1200
            echo "MTU of tun0 set to 1200"
        else
            # Do nothing if the MTU is already 1200
            echo "MTU of tun0 is already 1200, no changes made."
        fi      
    fi

    # Wait before retrying the curl request (optional)
    sleep 2
done