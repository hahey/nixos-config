#!/bin/sh

# Copyright (C) 2020 Heuna Kim <heynaheyna9@gmail.com>

if [[ $# -ne 5 ]]; then
    echo "USAGE: $(basename "$0") DISK_DEVICE LVM_PARTITION PHYSICAL_VOLUME VOLUME_GROUP BOOT_PARTITION" >&2
    exit 1
fi

# partition
parted /dev/$1 -- mklabel gpt
parted /dev/$1 -- mkpart primary 512MiB 300GiB # set aside a remaining space for a future resize
parted /dev/$1 -- mkpart ESP fat32 1MiB 512MiB # let the boot partition not a part of LUKS
parted /dev/$1 -- set 3 esp on

# create LVM on LUKS
cryptsetup luksFormat /dev/$2
cryptsetup open /dev/$2 $3
pvcreate /dev/mapper/$3
vgcreate $4 /dev/mapper/$3
lvcreate -L 14G $4-lv01_swap -n swap
lvcreate -L 32G $4-lv02_root -n root
lvcreate -L 10G $4-lv03_var -n var
lvcreate -L 2G $4-lv04_tmp -n tmp
lvcreate -L 150G $4-lv05_home -n home # set aside a remaining space for a future resize
#lvcreate -l 100%Free $4-lv05_home -n home

# Format
mkfs.ext4 /dev/$4/root
mkfs.ext4 /dev/$4/var
mkfs.ext4 /dev/$4/home
mkfs.ext4 /dev/$4/tmp
mkswap /dev/$4/swap
mkfs.fat -F32 /dev/$5

# mount
mkdir /mnt/{boot,var,home,tmp}
mount /dev/$4/root /mnt
mount /dev/$4/home /mnt/home
mount /dev/$5 /mnt/boot

mount -o rw,nosuid,nodev /dev/$4/var /mnt/var
mount -o rw,nosuid,nodev,relatime /dev/$4/tmp /mnt/tmp

#install
nixos-generate-config --root /mnt
nixos-install

# after rebooting and relogging with an user
# $./linking.sh <USERNAME> <HOSTNAME>
# $ sudo nixos-rebuild switch
# $ home-manager switch
