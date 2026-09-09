#!/bin/bash
# Phase 5: UFW Firewall Hardening Rules
# Reset default policies to zero-trust
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow standard HTTP and HTTPS web traffic
sudo ufw allow 80/tcp comment 'Allow HTTP'
sudo ufw allow 443/tcp comment 'Allow HTTPS'

# Restrict SSH strictly to Tailscale VPN interface
sudo ufw allow in on tailscale0 to any port 22 proto tcp comment 'SSH strictly over Tailscale'

# Enable firewall
sudo ufw --force enable
sudo ufw status verbose
