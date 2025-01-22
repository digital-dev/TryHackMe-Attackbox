FROM kalilinux/kali-rolling

# Set the frontend to non-interactive to avoid debconf issues
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install packages
RUN apt-get update && \
    apt-get install -y kali-linux-headless
RUN apt-get install -y seclists evil-winrm inetutils-ping gobuster htop tmux man-db burpsuite firefox-esr default-jre zaproxy python3-fuzzywuzzy && \
    apt-get install -y feroxbuster oscanner redis-tools sipvicious tnscmd10g wkhtmltopdf python3-toml python3-unidecode terminator
 # Default tools: kali-linux-headless

# Remove files from nginx html
RUN rm -rf /var/www/html/*

# Clone the repositories into the /opt directory
RUN     git clone https://github.com/Pennyw0rth/NetExec /opt/NetExec && \
        git clone https://github.com/RustScan/RustScan /opt/RustScan && \
        git clone https://github.com/Tib3rius/AutoRecon /opt/AutoRecon && \
        git clone https://github.com/s0md3v/XSStrike /opt/XSStrike && \
        mkdir /var/www/html/peas && \
        wget https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh -P /var/www/html/peas && \
        wget https://github.com/peass-ng/PEASS-ng/releases/latest/download/winPEASany.exe -P /var/www/html/peas && \
        mkdir /var/www/html/pspy && \
        wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64 -P /var/www/html/pspy && \
        wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32 -P /var/www/html/pspy

# Clean up apt lists to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Create a directory for tryhackme files
RUN mkdir -p /root/tryhackme/

# Copy local files into the image
COPY VPN/tryhackme.ovpn /root/tryhackme/connect.ovpn
COPY tryhackme/tryhackme.sh /root/tryhackme/tryhackme.sh
COPY tryhackme/vpn.sh /root/tryhackme/vpn.sh
COPY tryhackme/restart-vpn.sh /root/tryhackme/restart-vpn.sh
COPY linux/.bashrc /root/.bashrc

# Ensure the tryhackme.sh script is executable
RUN chmod +x /root/tryhackme/tryhackme.sh
RUN chmod +x /root/tryhackme/vpn.sh

# Set the default entrypoint to bash
ENTRYPOINT ["/bin/bash", "-l", "-c", "bash /root/tryhackme/tryhackme.sh; exec bash"]

# Running the machine:
# docker run --rm -t -i --privileged redteam

# Running the machine With X11 Forwarding and persistent firefox profile:
#$ip = Get-NetIPAddress | Where-Object AddressState -eq "Preferred" | where ValidLifeTime -lt "24:00:00" | select -ExpandProperty IPAddress
#$DISPLAY = "$IP`:0.0"
#docker run -v firefox:/root/.mozilla/firefox -v redteam-root:/root/.bash_history -v redteam-root:/root/.bash_aliases --rm -t -i --privileged --env DISPLAY=$DISPLAY redteam

#$ip = Get-NetIPAddress | Where-Object AddressState -eq "Preferred" | where ValidLifeTime -lt "24:00:00" | select -ExpandProperty IPAddress;$DISPLAY = "$IP`:0.0";docker run -v firefox:/root/.mozilla/firefox -v redteam-root:/root/.bash_history -v redteam-root:/root/.bash_aliases --rm -t -i --privileged --env DISPLAY=$DISPLAY redteam