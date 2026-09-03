#!/bin/bash
set -e

echo "=== Installing QEMU/KVM on Arch Linux ==="

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}[1/5] Checking virtualization support...${NC}"
if grep -E '(vmx|svm)' /proc/cpuinfo > /dev/null; then
    echo -e "${GREEN}✓ Virtualization supported${NC}"
else
    echo -e "${RED}✗ Virtualization not detected!${NC}"
    echo "Check whether it is enabled in the BIOS/UEFI"
    exit 1
fi

echo -e "${YELLOW}[2/5] Installing QEMU/KVM packages...${NC}"
sudo pacman -S --needed \
    qemu-full \
    libvirt \
    virt-manager \
    virt-viewer \
    dnsmasq \
    bridge-utils \
    ebtables \
    iptables-nft \
    openbsd-netcat

echo -e "${YELLOW}[3/5] Configuring the libvirt service...${NC}"
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

echo -e "${YELLOW}[4/5] Adding the user to groups...${NC}"
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

echo -e "${YELLOW}[5/5] Configuring the default network...${NC}"
sudo virsh net-autostart default
sudo virsh net-start default 2>/dev/null || echo "Network already started"

echo ""
echo -e "${GREEN}=== Installation Completed! ===${NC}"
echo ""
echo "Service status:"
systemctl status libvirtd.service --no-pager -l | head -3

echo ""
echo "User groups:"
groups $USER

echo ""
echo -e "${YELLOW}IMPORTANT:${NC}"
echo "1. Log out and sign in again to apply the group permissions"
echo "2. Or run: newgrp libvirt"
echo ""
echo "Useful commands:"
echo "  virt-manager          - Graphical interface"
echo "  virsh list --all      - List VMs"
echo "  virsh net-list        - List networks"
echo ""
echo "To test:"
echo "  virsh version"
