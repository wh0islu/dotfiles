#!/bin/bash

set -e

echo "=== Instalando QEMU/KVM no Arch Linux ==="

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}[1/5] Verificando suporte à virtualização...${NC}"
if grep -E '(vmx|svm)' /proc/cpuinfo > /dev/null; then
    echo -e "${GREEN}✓ Virtualização suportada${NC}"
else
    echo -e "${RED}✗ Virtualização não detectada!${NC}"
    echo "Verifique se está habilitada na BIOS/UEFI"
    exit 1
fi

echo -e "${YELLOW}[2/5] Instalando pacotes QEMU/KVM...${NC}"
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

echo -e "${YELLOW}[3/5] Configurando serviço libvirt...${NC}"
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

echo -e "${YELLOW}[4/5] Adicionando usuário aos grupos...${NC}"
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

echo -e "${YELLOW}[5/5] Configurando rede padrão...${NC}"
sudo virsh net-autostart default
sudo virsh net-start default 2>/dev/null || echo "Rede já iniciada"

echo ""
echo -e "${GREEN}=== Instalação Concluída! ===${NC}"
echo ""
echo "Status dos serviços:"
systemctl status libvirtd.service --no-pager -l | head -3

echo ""
echo "Grupos do usuário:"
groups $USER

echo ""
echo -e "${YELLOW}IMPORTANTE:${NC}"
echo "1. Faça logout e login novamente para aplicar as permissões de grupo"
echo "2. Ou execute: newgrp libvirt"
echo ""
echo "Comandos úteis:"
echo "  virt-manager          - Interface gráfica"
echo "  virsh list --all      - Listar VMs"
echo "  virsh net-list        - Listar redes"
echo ""
echo "Para testar:"
echo "  virsh version"
