# Install Arch Linux - My usual steps

## Keyboard layout

```$ loadkeys us```

## UEFI or BIOS?

Check this (dellxps13):

```$ ls /sys/firmware/efi/efivars ```

If the directory does not exist, the system may be booted in BIOS or CSM mode.

## Disks

### Check disk name

```$ lsblk ```

### Create boot partition

```
(parted) /dev/drive
(parted) mklabel gpt
(parted) mkpart ESP fat32 1MiB 513MiB
(parted) set 1 boot on
```
### System and home partitions
```
(parted) mkpart primary ext4 513MiB 30GiB
(parted) mkpart primary linux-swap 30GiB 38GiB
(parted) mkpart primary ext4 38GiB 100%
(parted) quit  
 ```

 ### Format partitions

 ```
$ mkfs.ext4 /dev/drive/sys_partition
$ mkfs.ext4 /dev/drive/home_partition
$ mkfs.fat -F32 /dev/drive/boot_partition
 ```

 ### Swap
 ```
$ mkswap /dev/drive/swap_partition
$ swapon /dev/drive/swap_partition
 ```

 ### Mounting partitions

```
$ mount /dev/drive/sys_partition /mnt
$ mkdir -p /mnt/boot
$ mkdir -p /mnt/home
$ mount /dev/drive/boot_partition /mnt/boot
$ mount /dev/drive/home_partition /mnt/home
```

## Installing the system

### Select a mirror

```
/etc/pacman.d/mirrorlist
```

### Install base packages

```
$ pacstrap -i /mnt base base-devel
```

### Generate fstab
```
$ genfstab -U /mnt > /mnt/etc/fstab
```

## Setting up the new system

```
$ arch-chroot /mnt /bin/bash
```

### Setup bootloader

```
$ bootctl --path=/boot install
```

On
``
/boot/loader/loader.conf
``

```
default arch
timeout 1
editor 0
```

Getting UUID of root partition

```
$ blkid -s PARTUUID -o value /dev/disk/root_partition
```

On
``
/boot/loader/loader.conf
``

```
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=66e3f67d-f59a-4086-acdd-a6e248a3ee80 rw
```

Update bootloader

```bash
$ bootctl update
# add modules to /etc/mkinitcpio if its necessary
$ mkinitcpio -p linux
```

## Configure locales

On
``
/etc/locale.gen
``
pick one

```
$ locale-gen
$ echo LANG=en_US.UTF-8 > /etc/locale.conf
$ export LANG=en_US.UTF-8
$ tzselect
$ ln -s /usr/share/zoneinfo/what/ever  /etc/localtime
$ hwclock --systohc --utc
```

## User management

### root password

```
$ passwd
```

### new user

```
$ useradd -m -G wheel,users -s /bin/bash username
$ passwd username
```

## Installing software

**audio:** alsa-utils

**x server:** xorg-server xorg-xinit xorg-utils xorg-server-utils

**graphic card drivers: ** https://wiki.archlinux.org/index.php/xorg#Driver_installation

**networking:** wpa_supplicant network-manager-applet networkmanager

**desktop:** xfce4, awesome, xfce4-goodies

**others:** check packages.txt and repositories.txt

```
$ pacman -S sudo
$ EDITOR=nano visudo
$ %wheel ALL=(ALL) ALL
```

Set ``/etc/hostname``

On
``
/etc/pacman.conf
``

```
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```
### useful links
https://www.cio.com/article/3098030/how-to-install-arch-linux-on-dell-xps-13-2016-in-7-steps.html


