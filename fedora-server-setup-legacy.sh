#!/bin/bash

# Ensure script is run as root
if [ "$(id -u)" -ne 0 ]; then echo "Please run as root." >&2; exit 1; fi

# Change hostname
echo "### Changing hostname ###"
sleep 2
echo "Enter the hostname of the server"
read host_name
hostnamectl set-hostname $host_name
sleep 2

# Update repos and groups
echo "### Updating core repos ###"
sleep 2
dnf groupinstall -y "Fedora Server Edition" && \
dnf groupinstall -y "Container Management" && \
dnf groupinstall -y "Headless Management" && \
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
sleep 2

# Install base utilities
echo "Installing base system utilities"
dnf install -y \
cockpit-pcp \
cockpit-podman \
cockpit-machines \
curl \
git \
htop \
vim \
vim-syntastic \
wget && \
sleep 2

# Enable system services
echo "Enabling basic system services"
systemctl enable --now libvirtd && \
systemctl enable --now cockpit.socket && \
systemctl enable --now podman.socket &&\
firewall-cmd --permanent --zone=public --add-port=9090/tcp #Open cockpit port
sleep 2

# Install Tailscale
echo "Installing Tailscale"
dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo && \
dnf install tailscale -y && \
systemctl enable --now tailscaled && \
tailscale up && \
sleep 2

# Update and reboot
echo "Update everyrhing"
dnf update -y && \
echo "Time to reboot"
sleep 2
shutdown -r now
