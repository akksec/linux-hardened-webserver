# 🛡️ Hardened Linux Web Server Architecture

A university system administration and security project: Building an enterprise-grade, hardened Linux Web Server deployed on **Ubuntu Server** using **VMware Workstation (Bridged Networking)** following defense-in-depth principles.

---

## 📊 Project Roadmap & Progress

- [x] **Phase 1:** Static IP Configuration via Netplan
- [ ] **Phase 2:** SSH Hardening (Key-Based Authentication Only)
- [ ] **Phase 3:** Tailscale Encrypted Mesh VPN Setup
- [ ] **Phase 4:** Apache2 Web Server & VirtualHost Configuration
- [ ] **Phase 5:** UFW Firewall Hardening (Zero-Trust / Interface-bound)
- [ ] **Phase 6:** Fail2Ban Intrusion Prevention System
- [ ] **Phase 7:** Node.js Application with Apache Reverse Proxy

---

## 🚀 Phase 1: Static IP Configuration (Netplan)

### Overview
Converted the guest OS from dynamic DHCP to a deterministic static IP address in the local subnet to ensure predictable server accessibility and prevent connection drops.

### Configuration Applied
The configuration was applied to `/etc/netplan/` using the systemd `networkd` renderer:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: no
      addresses:
        - 192.168.96.229/23
      routes:
        - to: default
          via: 192.168.96.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
```

Verification & Evidence

Tested network configuration with sudo netplan try.
Applied permanently via sudo netplan apply.
Verified static allocation (valid_lft forever) and public connectivity.
