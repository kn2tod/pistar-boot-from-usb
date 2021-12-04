Booting Pi-Star from a USB on a Pi4!

An existing system on an mSD card can be cloned to a USB and made to 
boot natively on Raspberry Pi4's!

           THIS ONLY WORKS FOR BOOTING ON Pi4's!!!

All the current Rasp-Pi versions (up through Buster) are hard-wired to
use Micro SD (block) devices. The key is to rewire the system from using
a specific device type to a generic device type so that the system can
then be booted from either a mSD *or* uSD port.

So the migration process simply consists of modifying an existing system
a uSD device and cloning it to an uSD device.

(For the purposes of this documention, I use "mSD" to denote MultiMedia
cards (commonly referred to as "micro" cards), typically used in 
Raspberry Pi's; "uSD" is used to denote an appropriate device attached
via a USB port on the Pi, either a true USB-type device or other device
connected via an USB adapter.)

The outline of the migration process given below assumes you know your 
way around Rpi's, Pi-Star, Linux and the command line, editors, etc.

Read through ALL the steps below before attempting this conversion.

      REPEAT!  THIS ONLY WORKS FOR BOOTING ON Pi4's!!!

---

1) Prepare a new image on a spare mSD.  Build it with latest download:  
 <http://www.pistar.uk/downloads/Pi-Star_RPi_V4.1.5_30-Oct-2021.zip>.
 You can use BalenaEtcher here to download and burn directly from the URL.
 Do what you would normally do to gain access to this new image: drop 
 your wpa_supplicant.conf file into the boot directory so you can log 
 into the system after boot.  Or work off the Pi-Star-Setup Access Point.

2) Once you've booted up this image, log into the command (SSH) terminal
 and run the following commands.  (Skip all the usual configuration
 stuff and go directly to the command prompt.) 

    rpi-rw
    uuid=$(ls -la /dev/disk/by-partuuid | sed -n 's/^.* \([[:alnum:]]*-[0-9]* \).*/\1/p' | sed -n 's/\(.*\)-.*/\1/p' | head -n 1)
    sudo sed -i.bak "s|\/dev\/mmcblk0p2 |PARTUUID=$uuid-02 |g" /boot/cmdline.txt
    sudo sed -i.bak "s|\/dev\/mmcblk0p1|PARTUUID=$uuid-01|g" /etc/fstab
    sudo sed -i "s|\/dev\/mmcblk0p2|PARTUUID=$uuid-02|g" /etc/fstab
    sudo sed -i.bak "s/mmcblk0p2 /\x2e\x2a /g" /etc/bash.bashrc
    source /etc/bash.bashrc
    rpi-ro

  Alternately, you can download and run these commands from GIT:

    wget 'https://raw.githubusercontent.com/kn2tod/pistar-boot-from-usb/main/Fix-Pi-Star-Boots.sh'
    sudo bash Fix-Pi-Star-Boots.sh

  The scripts create backups (.bak files) of the cmdline.txt and fstab files in the 
  appropriate directories, in case you run into problems.

4) Reboot your mSD to make sure the image still works, that you haven't made any
  typos. Skip further configuring here - you can do all that AFTER you boot your uSD 
  system. Shut it down again.

5) Using BalenaEtcher again, clone the mSD to a uSD (USB drive).

  Use a GOOD uSD drive. 32gb is more than enough.  Some drives are simply sloooooow, so you may
  have to try several different brands/models.  Unfortunately, you won't know which drives are
  better/faster until you give 'em a try in step 6.

  *IF* you have a config backup from a prior working system, this would be the time to drop
  a copy of that zip file into the /boot directory.

6) Boot'er up and complete the configuration process same as you would have done for the mSD.
  (or let the system work it's magic and configure the system from the zip backup). Either one
  of the USB 3.0 ports should be used here.

---

For those who have been working with Pi-Star for a while should know, there are some
shortcuts you can take here:

Clone your existing working system to another mSD (just in case).  Best that the system
you are copying be up-to-date here. 

Boot up the copy and run the commands from step 3. 

Then clone this revised version to a uSD and boot it (steps 5 + 6).  You should be up and 
running instantly.

or

Live dangerously: run step 3 on your working system, then clone and boot (steps 5 + 6).
Again, you should be up and running in no time.  

---

Notes:

Configuration backups from PiZero-Pi3 systems should work just fine here, so this ends up 
being an easy why to migrate to better hardware (uSD's and Pi4's) at the same time.

The system modifications in step 3 can be applied to any system; their effect is transparent
when running from a mSD; they are required if running from a uSD. Translation: a working
uSD system can be cloned back to an mSD and redeployed to older Pi's, if the need arises.

---

Post-migration: 

Your new uSD retains the orginal allocation sizes set on the mSD's and does not automatically
increase when you first boot it up.  The same allocation sizes that worked for the mSD's
still work for uSD's.  (Issue "df -h" command before/after migration to verify this.)

Raspi-Config does not exist natively in Pi-Star, but it can be installed (sudo apt install 
raspi-config) and then run to effect an expansion, if you see a need.

---

kn2tod
mark
 



