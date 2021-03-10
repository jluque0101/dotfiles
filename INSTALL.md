# Install Arch Linux - My usual steps

## Keyboard layout

```$ loadkeys us```

## UEFI or BIOS?

Check this (dellxps13):

```$ ls /sys/firmware/efi/efivars ```

If the directory does not exist, the system may be booted in BIOS or CSM mode.

## Disks

### Check disk name

1. Install Windows 
2. Create partition with the remaining space on nvme
3. Create partition on the secondary disk
4. Create physical volumes   
4.1 pvcreate /dev/nvme0n1pX - stands for linux lvm
4.2 pvcreate /dev/sdaX - stands for data storage disk
5. Create volume groups
5.1 vgcreate nvme /dev/nvme0n1pX
5.2 vgcreate slow /dev/sdaX
6. Create logical volumes
6.1 lvcreate -L 80G nvme -n root
6.2 lvcreate -L 512M nvme -n boot
6.3 lvcreate -L 300G nvme -n home
6.4 lvcreate -L 80G nvme -n containers
6.5 lvcreate -L 120G slow -n data
```
pvdisplay
  --- Physical volume ---
  PV Name               /dev/nvme0n1p2
  VG Name               nvme
  PV Size               600.00 GiB / not usable 4.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              153599
  Free PE               35711
  Allocated PE          117888
  PV UUID               WBURCP-2vhX-RuMj-ub71-ZXNJ-0E12-8iLRgD
   
  --- Physical volume ---
  PV Name               /dev/sda1
  VG Name               slow
  PV Size               931.51 GiB / not usable 4.69 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              238466
  Free PE               110466
  Allocated PE          128000
  PV UUID               2R8Aod-7Jnc-ia44-x3nr-koIY-dgBB-M7CWiS
```

### Mounting partitions
```
mount /dev/nvme/root /mnt
mkdir -p /mnt/boot/efi /mnt/home/jose/data /var/lib/docker
mount /dev/nvme/home /mnt/home
mount /dev/nvme/boot /mnt/boot
mount /dev/slow/data /mnt/home/jose/data
mount /dev/nvmen0pX /mnt/boot/efi # This already should contain windows EFI
```

### Final state
```$ lsblk 
NAME                MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                   8:0    0 931.5G  0 disk 
└─sda1                8:1    0 931.5G  0 part 
  └─slow-data       254:4    0   500G  0 lvm  /home/jose/data
nvme0n1             259:0    0 931.5G  0 disk 
├─nvme0n1p1         259:1    0   100M  0 part /boot/efi
├─nvme0n1p2         259:2    0   600G  0 part 
│ ├─nvme-root       254:0    0    80G  0 lvm  /
│ ├─nvme-boot       254:1    0   512M  0 lvm  /boot
│ ├─nvme-home       254:2    0   300G  0 lvm  /home
│ └─nvme-containers 254:3    0    80G  0 lvm  /var/lib/docker
├─nvme0n1p3         259:3    0    16M  0 part 
└─nvme0n1p4         259:4    0 331.4G  0 part 
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

**amd:** amd-ucode

**x server:** xorg-server xorg-xinit xorg-utils xorg-server-utils

**graphic card drivers: ** nvidia, nvidia-settings

**networking:** wpa_supplicant network-manager-applet networkmanager iwctl

**desktop:** xfce4, awesome, xfce4-goodies, vim

**boot:** grub, os-prober, efibootmgr

**others:** check packages.txt and repositories.txt , can be done afterwards

```
$ pacman -S sudo
$ EDITOR=vim visudo
$ %wheel ALL=(ALL) ALL
```

Set ``/etc/hostname``

## Install grub
Update `/etc/default/grub` adding lvm
Update `/etc/mkinitcpio.conf` adding lvm2
```
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcipio -P
```
