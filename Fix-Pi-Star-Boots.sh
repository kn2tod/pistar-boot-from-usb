#!/bin/bash
# Basic modifications to a working Pi-Star system so it can be cloned to alternate devices
#
#rpi-rw
sudo mount -o remount,rw / ; sudo mount -o remount,rw /boot
#
# extract the current partition id (partuuid) from system tables:
uuid=$(ls -la /dev/disk/by-partuuid | sed -n 's/^.* \([[:alnum:]]*-[0-9]* \).*/\1/p' | sed -n 's/\(.*\)-.*/\1/p' | head -n 1)
# modify the boot cmdline to point to this PARTUUID:
sudo sed -i.bak "s|\/dev\/mmcblk0p2 |PARTUUID=$uuid-02 |g" /boot/cmdline.txt
# likewise, modify the File System Table (fstab):
sudo sed -i.bak "s|\/dev\/mmcblk0p1|PARTUUID=$uuid-01|g" /etc/fstab
sudo sed -i "s|\/dev\/mmcblk0p2|PARTUUID=$uuid-02|g" /etc/fstab
# fix terminal commmand prompt so the disk RO/RW status displays properly:
sudo sed -i.bak "s/mmcblk0p2 /\x2e\x2a /g" /etc/bash.bashrc
# ... and reload it just for the heck of it:
source /etc/bash.bashrc
#
#rpi-ro
sudo mount -o remount,ro / ; sudo mount -o remount,ro /boot
#
