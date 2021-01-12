#!/bin/sh

# Copyright (C) 2020 Heuna Kim <heynaheyna9@gmail.com>

if [[ $# -ne 5 ]]; then
    echo "USAGE: $(basename "$0") DISK_DEVICE_NAME CRYPT_PARTITION_LUKS BOOT_PARTITION PHYSICAL_VOLUME VOLUME_GROUP " >&2
    exit 1
fi

DISK_DEVICE="/dev/$1"
CRYPT_PARTITION_LUKS="/dev/$2"
BOOT_PARTITION="/dev/$3"
PHYSICAL_VOLUME="$4"
VOLUME_GROUP="$5"

# partition
parted "$DISK_DEVICE" -- mklabel gpt
parted "$DISK_DEVICE" -- mkpart primary 512MiB 300GiB # set aside a remaining space for a future resize
parted "$DISK_DEVICE" -- mkpart ESP fat32 1MiB 512MiB # let the boot partition not a part of LUKS
parted "$DISK_DEVICE" -- set 2 esp on

# create LVM on LUKS
cryptsetup luksFormat "$CRYPT_PARTITION_LUKS"
cryptsetup luks open "$CRYPT_PARTITION_LUKS" "$PHYSICAL_VOLUME"
pvcreate /dev/mapper/"$PHYSICAL_VOLUME"
vgcreate "$VOLUME_GROUP" /dev/mapper/"$PHYSICAL_VOLUME"
lvcreate -L 14G "$VOLUME_GROUP" -n lv01_swap
lvcreate -L 32G "$VOLUME_GROUP" -n lv02_root
lvcreate -L 10G "$VOLUME_GROUP" -n lv03_var
lvcreate -L 150G "$VOLUME_GROUP" -n lv04_home # set aside a remaining space for a future resize
#lvcreate -l 100%Free "$VOLUME_GROUP" -n lv05_home

# Format
mkfs.ext4 /dev/"$VOLUME_GROUP"/root
mkfs.ext4 /dev/"$VOLUME_GROUP"/var
mkfs.ext4 /dev/"$VOLUME_GROUP"/home
mkswap /dev/"$VOLUME_GROUP"/swap
swapon /dev/"$VOLUME_GROUP"/swap
mkfs.fat -F32 "$BOOT_PARTITION"

# mount
mount /dev/"$VOLUME_GROUP"/root /mnt
mkdir /mnt/{home,boot,var,tmp}

mount /dev/"$VOLUME_GROUP"/home /mnt/home
mount "$BOOT_PARTITION" /mnt/boot

mount -o rw,nosuid,nodev /dev/"$VOLUME_GROUP"/var /mnt/var
mount -o rw,nosuid,nodev,relatime,size=6G,mode=1777 TMPFS -t tmpfs /mnt/tmp

#install
nixos-generate-config --root /mnt
nixos-install

# after rebooting and relogging with an user
# $./linking.sh <USERNAME> <HOSTNAME>
# $ sudo nixos-rebuild switch
# $ home-manager switch
