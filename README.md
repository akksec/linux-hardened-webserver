# 🛡️ Hardened Linux Web Server Architecture

A university system administration and security project: Building an enterprise-grade, hardened Linux Web Server deployed on **Ubuntu Server** using **VMware Workstation (Bridged Networking)** following defense-in-depth principles.

---

## 📊 Project Roadmap & Progress

- [x] **Phase 1:** Static IP Configuration via Netplan
- [x] **Phase 2:** SSH Hardening (Key-Based Authentication Only)
- [x] **Phase 3:** Tailscale Encrypted Mesh VPN Setup
- [x] **Phase 4:** Apache2 Web Server & VirtualHost Configuration
- [x] **Phase 5:** UFW Firewall Hardening (Zero-Trust / Interface-bound)
- [x] **Phase 6:** Fail2Ban Intrusion Prevention System
- [ ] **Phase 7:** Node.js Application with Apache Reverse Proxy

---

## 🚀 Phase 1: Static IP Configuration (Netplan)

### Overview
Converted the guest OS from dynamic DHCP to a deterministic static IP address in the local subnet to ensure predictable server accessibility.

### Configuration Applied
Applied to `/etc/netplan/` using systemd `networkd` renderer:
- **Interface:** `ens33`
- **Static IP:** `192.168.96.229/23`
- **Gateway:** `192.168.96.1`

![Phase 1 Verification](screenshots/01-netplan-ip.png)

---

## 🔐 Phase 2: SSH Hardening & Key-Based Authentication

### Overview
Eliminated password authentication attack vectors by enforcing modern cryptographic key-based authentication (Ed25519) and applying daemon-level security constraints.

### Security Configurations Applied
Added drop-in override at `/etc/ssh/sshd_config.d/99-hardened.conf`:
- `PubkeyAuthentication yes`: Enabled public key authentication.
- `PasswordAuthentication no`: Blocked all password-based logins.
- `PermitEmptyPasswords no`: Prohibited blank password attempts.
- `PermitRootLogin prohibit-password`: Prevented direct root access via password.
- `MaxAuthTries 3`: Mitigated brute-force connection floods.

![Phase 2 Verification](screenshots/02-ssh-denied.png)

---

## 🌐 Phase 3: Tailscale Encrypted Mesh VPN Tunnel

### Overview
Established an authenticated, peer-to-peer WireGuard-based encrypted mesh VPN tunnel between the Windows management host and the Ubuntu guest server to isolate administrative access.

### Key Implementation Details
- Virtual tunnel adapter created: `tailscale0`
- Assigned Overlay Private IPv4: `100.70.130.83`
- Verified end-to-end transport connectivity via `tailscale ping` (successful pong reply) and authenticated SSH session over the overlay IP.

![Phase 3 Verification](screenshots/03-tailscale-status.png)

---

## 🌐 Phase 4: Apache2 Web Server & VirtualHost Configuration

### Overview
Deployed production-ready Apache2 HTTP server, isolated content into a dedicated document root, and pre-configured required reverse proxy modules for downstream application integration.

### Key Implementation Details
- Enabled core modules: `proxy`, `proxy_http`, `headers`, `rewrite`.
- Created custom VirtualHost at `/etc/apache2/sites-available/app.conf` bound to document root `/var/www/site/public_html`.
- Deactivated default site (`000-default.conf`) and confirmed syntax validation (`Syntax OK`).

![Phase 4 Verification](screenshots/04-apache-vhost.png)

---

## 🔥 Phase 5: UFW Firewall Hardening (Zero-Trust Model)

### Overview
Configured Uncomplicated Firewall (UFW) enforcing default-deny ingress and interface-bound port filtering to minimize exposure surface.

### Security Rules Implemented
- Default Ingress Policy: `deny (incoming)`
- Default Egress Policy: `allow (outgoing)`
- Public Web Ports: `80/tcp` (HTTP) & `443/tcp` (HTTPS) permitted from all sources.
- Management Access: `22/tcp` (SSH) is strictly bound to the `tailscale0` VPN interface, completely blocking unauthorized access attempts originating from the physical local area network (LAN).

![Phase 5 Verification](screenshots/05-ufw-status.png)

---

## 🚫 Phase 6: Fail2Ban Intrusion Prevention System

### Overview
Integrated Fail2Ban to monitor authentication telemetry and automatically ban IP addresses demonstrating repeated failed authentication patterns or brute-force behavior.

### Security Configuration
Applied custom jail configuration at `/etc/fail2ban/jail.local`:
- Monitored Jail: `[sshd]`
- Telemetry Backend: `systemd` (journald-integrated)
- Rate Limits: Threshold of 3 failed authentication attempts (`maxretry = 3`) within a 10-minute discovery window (`findtime = 10m`).
- Ban Penalty: 24-hour network ban (`bantime = 24h`) enforced via dynamic packet filtering.

![Phase 6 Verification](screenshots/06-fail2ban-status.png)
