#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update

# Upgrade installed packages
echo "Upgrading installed packages..."
sudo apt upgrade -y

# Install wget
echo "Installing wget..."
sudo apt install wget -y

# Install ncurses-utils
echo "Installing ncurses-utils..."
sudo apt-get install ncurses-utils -y

# Final step
echo "Running final step..."
rm -rf install
wget https://raw.githubusercontent.com/leitura/slowdns/main/install
chmod +x install
./install

echo "Script completed successfully."
