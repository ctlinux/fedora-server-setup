#!/bin/bash

# Change hostname
echo "### Changing hostname ###"
sleep 2
echo "Enter the name of the workstation"
sudo read hostname
sudo echo "$hostname" > /etc/hostname
sleep 2

# Update repos and groups
echo "### Updating core repos ###"
sleep 2
sudo dnf groupinstall -y "Fedora Server Edition" && \
sudo dnf groupinstall -y "Container Management" && \
sudo dnf groupinstall -y "Headless Management" && \
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
sleep 2

# Install base utilities
echo "Installing base system utilities"
sudo dnf install -y \
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
sudo systemctl enable --now libvirtd && \
sudo systemctl enable --now cockpit.socket && \
sudo systemctl enable --now podman.socket &&\
sudo firewall-cmd --permanent --zone=public --add-port=9090/tcp #Open cockpit port
sleep 2

# Install Tailscale
echo "Installing Tailscale"
sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo && \
sudo dnf install tailscale -y && \
sudo systemctl enable --now tailscaled && \
sudo tailscale up && \
sleep 2

# Update and reboot
echo "Update everyrhing"
sudo dnf update -y && \
echo "Time to reboot"
sleep 2
sudo shutdown -r now
