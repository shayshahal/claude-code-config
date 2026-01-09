#!/bin/bash
set -e

echo "=== Setting up SSH for Terminus access ==="

# Install OpenSSH server
echo "[1/4] Installing OpenSSH server..."
sudo apt update && sudo apt install -y openssh-server

# Backup and configure sshd_config
echo "[2/4] Configuring SSH..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Ensure key settings are enabled
sudo sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Start SSH service
echo "[3/4] Starting SSH service..."
sudo service ssh start

# Get IP info
echo "[4/4] Getting connection info..."
echo ""
echo "=== CONNECTION INFO ==="
echo "WSL IP: $(hostname -I | awk '{print $1}')"
echo "Username: $(whoami)"
echo ""
echo "=== NEXT STEPS ==="
echo "Run this in PowerShell as Admin on Windows:"
echo ""
WSL_IP=$(hostname -I | awk '{print $1}')
echo "netsh interface portproxy add v4tov4 listenport=22 listenaddress=0.0.0.0 connectport=22 connectaddress=$WSL_IP"
echo ""
echo "New-NetFirewallRule -DisplayName 'SSH' -Direction Inbound -LocalPort 22 -Protocol TCP -Action Allow"
echo ""
echo "Then get your Windows LAN IP with: ipconfig"
echo "Use that IP in Terminus to connect."
