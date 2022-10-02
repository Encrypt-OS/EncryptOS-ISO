#!/usr/bin/env bash

# Warning
echo Before Preparing To Compile, Ensure the SKEL is compiled, otherwise ECOS will not boot.

# Get mirrorlist for offline installs
wget -qN --show-progress -P "airootfs/etc/pacman.d/" "https://raw.githubusercontent.com/Encrypt-OS/EncryptOS-ISO/main/mirrorlist"

# Get default mkinitcpio.conf
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/archlinux/mkinitcpio/master/mkinitcpio.conf"

# Get wallpaper for installed system
wget -qN --show-progress -P "airootfs/root/" "https://github.com/Encrypt-OS/encryptos-theming/raw/main/backgrounds/encryptos-wallpaper.png"

# Make sure build scripts are executable
chmod +x "./"{"mkarchiso","prepare.sh","run_before_squashfs.sh"}

get_pkg() {
    sudo pacman -Syw "$1" --noconfirm --cachedir "airootfs/root/packages" \
    && sudo chown $USER:$USER "airootfs/root/packages/"*".pkg.tar"*
}

get_pkg "encryptos-skel-xfce4"