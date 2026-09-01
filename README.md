# 🛡️ Hardened Linux Web Server Architecture

A university system administration and security project: Building an enterprise-grade, hardened Linux Web Server deployed on **Ubuntu Server** using **VMware Workstation (Bridged Networking)** following defense-in-depth principles.

---

## 📊 Project Roadmap & Progress

- [x] **Phase 1:** Static IP Configuration via Netplan
- [x] **Phase 2:** SSH Hardening (Key-Based Authentication Only)
- [ ] **Phase 3:** Tailscale Encrypted Mesh VPN Setup
- [ ] **Phase 4:** Apache2 Web Server & VirtualHost Configuration
- [ ] **Phase 5:** UFW Firewall Hardening (Zero-Trust / Interface-bound)
- [ ] **Phase 6:** Fail2Ban Intrusion Prevention System
- [ ] **Phase 7:** Node.js Application with Apache Reverse Proxy

---

## 🚀 Phase 1: Static IP Configuration (Netplan)

### Overview
Converted the guest OS from dynamic DHCP to a deterministic static IP address in the local subnet to ensure predictable server accessibility.

### Configuration Applied
Applied to \/etc/netplan/\ using systemd \
etworkd\ renderer:
- **Interface:** \ens33\
- **Static IP:** \192.168.96.229/23\
- **Gateway:** \192.168.96.1\

![Phase 1 Verification](screenshots/01-netplan-ip.png)

---

## 🔐 Phase 2: SSH Hardening & Key-Based Authentication

### Overview
Eliminated password authentication attack vectors by enforcing modern cryptographic key-based authentication (Ed25519) and applying daemon-level security constraints.

### Security Configurations Applied
Added drop-in override at \/etc/ssh/sshd_config.d/99-hardened.conf\:
- \PubkeyAuthentication yes\: Enabled public key authentication.
- \PasswordAuthentication no\: Blocked all password-based logins.
- \PermitEmptyPasswords no\: Prohibited blank password attempts.
- \PermitRootLogin prohibit-password\: Prevented direct root access via password.
- \MaxAuthTries 3\: Mitigated brute-force connection floods.

### Verification & Evidence
1. Successfully authenticated using \id_ed25519\ private key without password prompts.
2. Verified that password login attempts are completely dropped with \Permission denied (publickey)\.

![Phase 2 Verification](screenshots/02-ssh-denied.png)
