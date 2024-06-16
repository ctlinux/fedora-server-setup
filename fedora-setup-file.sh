#!/bin/bash

# Change hostname
echo "### Changing hostname ###"
sleep 2
echo "Enter the name of the workstation"
sudo read hostname
sudo echo "$hostname.localdomain" > /etc/hostname
sleep 2

# Update repos and groups
echo "### Updating core repos ###"
sleep 2
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate core -y
sudo dnf install -y rpmfusion-free-release-tainted
sudo dnf install  -y rpmfusion-nonfree-release-tainted
sudo dnf install \*-firmware -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sleep 2

# Install base utilities
echo "Installing base system utilities"
sudo dnf install -y cockpit curl vim wget vim-syntastic git podman htop && \
sleep 2

# Enable system services
echo "Enabling basic system services"
sudo systemctl enable --now libvirtd && \
sudo systemctl enable --now cockpit.socket && \
sudo systemctl enable --now podman.socket &&\
sleep 2

# Install Tailscale
echo "Installing Tailscale"
sudo dnf config-manager --add-repo -y https://pkgs.tailscale.com/stable/fedora/tailscale.repo && \
sudo dnf install tailscale -y && \
sleep 2

# Update and reboot
echo "Update everyrhing"
sudo dnf update -y && \
echo "Time to reboot"
sleep 2
sudo shutdown -r now
