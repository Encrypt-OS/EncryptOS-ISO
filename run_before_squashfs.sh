#!/usr/bin/env bash

script_path=$(readlink -f "${0%/*}")
work_dir="work"

# Adapted from AIS. An excellent bit of code!
# all pathes must be in quotation marks "path/to/file/or/folder" for now.

arch_chroot() {
    arch-chroot "${script_path}/${work_dir}/x86_64/airootfs" /bin/bash -c "${1}"
}

do_merge() {

arch_chroot "$(cat << EOF

echo "##############################"
echo "# start chrooted commandlist #"
echo "##############################"

cd "/root"

# Init & Populate keys
pacman-key --init
pacman-key --lsign-key AEA41F137D60202D1A2D3EB786CD105462642978
pacman-key --populate archlinux

# Install liveuser skel (in case of conflicts use overwrite)
pacman -U --noconfirm --overwrite "/etc/skel/.bash_profile","/etc/skel/.bashrc" -- "/root/encryptos-skel-liveuser/"*".pkg.tar.zst"

# Prepare livesession settings and user
sed -i 's/#\(en_US\.UTF-8\)/\1/' "/etc/locale.gen"
locale-gen
ln -sf "/usr/share/zoneinfo/UTC" "/etc/localtime"

# Set root permission and shell
usermod -s /usr/bin/bash root

# Create liveuser
useradd -m -p "" -g 'liveuser' -G 'sys,rfkill,wheel,uucp,nopasswdlogin,adm,tty' -s /bin/bash liveuser

# Remove liveuser skel to then install user skel
pacman -Rns --noconfirm -- "encryptos-skel-liveuser"
rm -rf "/root/encryptos-skel-liveuser"

# Root qt style for Calamares
mkdir "/root/.config"
cp -Rf "/home/liveuser/.config/"{"Kvantum","qt5ct"} "/root/.config/"

# Add builddate to motd:
cat "/usr/lib/encryptos-release" >> "/etc/motd"
echo "------------------" >> "/etc/motd"

# Enable systemd services
systemctl enable NetworkManager.service systemd-timesyncd.service bluetooth.service firewalld.service
systemctl enable vboxservice.service vmtoolsd.service vmware-vmblock-fuse.service
systemctl set-default multi-user.target

# Revert from arch-iso preset to default preset
cp -rf "/usr/share/mkinitcpio/hook.preset" "/etc/mkinitcpio.d/linux.preset"
sed -i 's?%PKGBASE%?linux?' "/etc/mkinitcpio.d/linux.preset"

# Patching EncryptOS specific grub config
patch -u "/etc/default/grub" -i "/root/grub.patch"
rm "/root/grub.patch"

# Patching mkinitcpio.conf
patch -u "mkinitcpio.conf" -i "/root/mkinitcpio.patch"
cp "mkinitcpio.conf" "/etc/"
rm "mkinitcpio.conf" "/root/mkinitcpio.patch"

# Remove unneeded grub stuff from /boot
rm -R "/boot/syslinux"
rm -R "/boot/memtest86+"
rm "/boot/amd-ucode.img"
rm "/boot/initramfs-linux.img"
rm "/boot/intel-ucode.img"
rm "/boot/vmlinuz-linux"

# Install locally builded packages on ISO (place packages under airootfs/root/packages)
pacman -U --noconfirm -- "/root/packages/"*".pkg.tar.zst"
rm -rf "/root/packages/"

# Set wallpaper for live-session and original for installed system
mv "encryptos-wallpaper.png" "/etc/calamares/files/encryptos-wallpaper.png"
mv "/root/livewall.png" "/usr/share/encryptos/backgrounds/encryptos-wallpaper.png"
chmod 644 "/usr/share/encryptros/backgrounds/"*".png"
rm -rf "/usr/share/backgrounds/xfce/xfce-verticals.png"
ln -s "/usr/share/encryptos/backgrounds/encryptos-wallpaper.png" "/usr/share/backgrounds/xfce/xfce-verticals.png"


# TEMPORARY CUSTOM FIXES

# Fix for getting bash configs installed
cp -af "/home/liveuser/"{".bashrc",".bash_profile"} "/etc/skel/"

# Move blacklisting nouveau out of ISO (copy back to target for offline installs)
mv "/usr/lib/modprobe.d/nvidia-utils.conf" "/etc/calamares/files/nv-modprobe"
mv "/usr/lib/modules-load.d/nvidia-utils.conf" "/etc/calamares/files/nv-modules-load"

# Get extra drivers!
mkdir "/opt/extra-drivers"
sudo pacman -Sw --noconfirm --cachedir "/opt/extra-drivers" r8168

# Clean pacman log
rm "/var/log/pacman.log"

echo "############################"
echo "# end chrooted commandlist #"
echo "############################"

EOF
)"
}

#################################
########## STARTS HERE ##########
#################################

do_merge
