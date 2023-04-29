#!/bin/bash

# Pre-install messages
pre_install() {
    printf "\nWarning: Please ensure that you are running the latest firmware!\n\n"
    printf "Device's side-switch should be in the down position (away from recessed dot).\n\n"
}

# Query GH API for latest download URL
get_latest() {
    local api_url='https://api.github.com/repos/srlabs/blue-merle/releases/latest'
    down_url=$(curl -sL $api_url | grep browser_download | awk -F '"' '{print $4}')
}

# Post-install messages
post_install() {
    printf '\n\nInstall complete, device will now reboot!\n'
    printf 'After device boots:\nFlip side-switch to the up position (towards recessed dot) and follow on-device MCU prompts.\n\n'
}

# Initialization
pre_install
read -p "Enter IP address: " ip_address
get_latest

# Begin SSH Connection
ssh root@$ip_address << 'ENDSSH'
cd /tmp
curl -L $down_url -o blue-merle.ipk
opkg update
opkg install blue-merle.ipk
reboot
ENDSSH

# Finish
post_install