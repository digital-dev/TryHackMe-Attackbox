#!/bin/bash

# Path to the OpenVPN configuration file
OVPN_FILE="/root/tryhackme/connect.ovpn"

# Start nginx
service nginx start

# Run OpenVPN with the .ovpn file in the background, redirecting output to a log file
# echo "Starting VPN with $OVPN_FILE..."
# sudo openvpn --config "$OVPN_FILE" > /root/openvpn.log 2>&1 &

# Keep the container running with an interactive bash shell
echo "VPN is running. Opening interactive shell..."
terminator > /dev/null 2>&1 &
firefox-esr > /dev/null 2>&1 &
/root/tryhackme/vpn.sh > /dev/null 2>&1 &
#tmux new-session -d -s "tryhackme" \; split-window -v \; select-pane -t 1 \; attach-session -t "tryhackme"

