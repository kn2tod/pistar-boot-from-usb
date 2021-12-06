Booting Pi-Star from a USB on a Pi4!

Modifications can be made to an existing or new image of a Pi-Star
system such that it can boot from USB's directly on Raspberry Pi4's.

All the current Pi-Star versions are hard-wired to use Micro SD (block)
devices. The key is to rewire the installation image to use a generic 
device type so that the system can then be booted from either an mSD *or* 
a uSD port. (This form of booting has always been around in the underlying
Raspbian base since at least the Jessie/Buster versions but for some reason 
has never been brought forward into the current images of Pi-Star.)

This modification is both simple AND tranparent: it does not effect the
continued use of mSD cards going forward, but the mod IS required to be 
able to boot from uSD ports on Pi4's.

Note:  ONLY Pi4's CAN BOOT DIRECTLY FROM USB PORTS!

[For the purposes of this documention, the term "mSD" is used to denote
MultiMedia cards (commonly referred to as "micro" cards), typically used
in Raspberry Pi's; "uSD" is used to denote an appropriate device attached
via a USB port on the Pi, either a true USB-type device or other device
connected via a USB adapter.]

[The outline of the conversion process given below assumes you know your 
way around Rpi's, Pi-Star, Linux and the command line, editors, etc. All
the development and testing involved using the lastest versions of
PiImager and BalenaEtcher.]

Carefully read through ALL the steps below before attempting this conversion.
Instructions apply to either modifying/cloning an existing system or to
starting from scratch with a new image.

---

1) Prepare a new image on a spare mSD.  Build it with latest download:  
 <http://www.pistar.uk/downloads/Pi-Star_RPi_V4.1.5_30-Oct-2021.zip>.
 You can use BalenaEtcher here to download and burn directly from the URL,
 or use PiImager with an unzipped copy of the image using the Custom Install
 selection.  

 Do what you would normally do to gain access to this new image: drop 
 your wpa_supplicant.conf file into the boot directory so you can log 
 into the system after boot.  Or work off the Pi-Star-Setup Access Point.

 *IF* starting with a new build, consider using a smaller mSD (8gb or 16gb)
 so as to cut down on the cloning time later; the target device can be the 
 same or larger size.  See note A below.

 *OR* you can use an existing mSD image or a clone of an existing system
 for the following steps.  Best that this system be up-to-date, at least
 from a Raspian perspective.

2) Once you've booted up this image, log into the command terminal (SSH)
 and run the following commands.  (If this is a new build, skip all the 
 usual configuration  stuff and go directly to the command prompt - you
 can configure later, after you get to your new device.) 

 With Internet access (easiest, safest bet), run the required commands from GIT:

    wget 'https://raw.githubusercontent.com/kn2tod/pistar-boot-from-usb/main/Fix-Pi-Star-Boots.sh'
    sudo bash Fix-Pi-Star-Boots.sh

 Without Internet access, key in these commands (or copy them off of GIT off-line):

    rpi-rw
    uuid=$(ls -la /dev/disk/by-partuuid | sed -n 's/^.* \([[:alnum:]]*-[0-9]* \).*/\1/p' | sed -n 's/\(.*\)-.*/\1/p' | head -n 1)
    sudo sed -i.bak "s|\/dev\/mmcblk0p2 |PARTUUID=$uuid-02 |g" /boot/cmdline.txt
    sudo sed -i.bak "s|\/dev\/mmcblk0p1|PARTUUID=$uuid-01|g" /etc/fstab
    sudo sed -i "s|\/dev\/mmcblk0p2|PARTUUID=$uuid-02|g" /etc/fstab
    sudo sed -i.bak "s/mmcblk0p2 /\x2e\x2a /g" /etc/bash.bashrc
    source /etc/bash.bashrc
    rpi-ro

  Either way, the scripts create backups of all the effected files in the 
  appropriate directories, in case you run into problems.  (See note B.)

  *IF* this is a new build, and you have an appropriate configuration backup from a working
  system, you can drop this into the /boot directory at this time.  (See note C.)

3) Reboot your mSD to make sure the image still works, that you haven't made any typos. 
  Skip further configuring here - you can do all that AFTER you boot your uSD system. 

  Or, again, if you have a configuration backup that you didn't drop into the /boot
  directory in step 2, you can do it now.  (See note C.)

  Shut down the system properly, less you corrupt the mSD.

4) Clone the mSD to a uSD (USB drive) - BalenaEtcher is a good choice here.

  Use a GOOD uSD drive. 32gb is more than enough.  Some drives are simply sloooooow, so you may
  have to try several different brands/models.  Unfortunately, you won't know which drives are
  better/faster until you give 'em a try in step 6.

  *IF* you have a config backup from a prior working system, this would be the time to drop
  a copy of that zip file into the /boot directory.

5) Boot up the new/revised drive and complete the configuration process same as you would have 
  done for the mSD (or let the system work its magic and configure the system from the zip 
  backup). Either one of the (blue) USB 3.0 ports can be used here.

  *IF* you got to this point using an existing, working system, you should be up and running
  without any further problems.

---

In Summary (Quick Guide):

1) On a new or existing system, log into the command terminal (SSH) and 
   run these commands (ref step 2 above):

    rpi-rw
    wget 'https://raw.githubusercontent.com/kn2tod/pistar-boot-from-usb/main/Fix-Pi-Star-Boots.sh'
    sudo bash Fix-Pi-Star-Boots.sh

2) Clone the mSD to a uSD (USB drive).

3) Plug the uSD into a Pi4 - you should be up and running in no time!


---

Notes:

A) All clones, either mSD's or uSD's, retain the partition allocation sizes set on the orignal
  mSD's and does not automatically increase when you boot up the copies.

  Raspi-Config does not exist natively in Pi-Star, but it can be installed (sudo apt install 
  raspi-config) and then run to effect an expansion, if you see a need.

B) The system modifications in step 2 can be applied to any system; their effect is transparent
  when running from a mSD; they are required if running from a uSD. 

  Translation: a working uSD system can be cloned back to an mSD and redeployed to older Pi's,
  if the need arises.

  Further, the the image created in steps 1 and 2 can be cloned over and over again; your 
  favorite  command line customizations (e.g. bash-aliases, etc) and utilites (e.g. htop, tree, 
  raspi-config, etc.) can pre-installed on this initial image before cloning.  The image can 
  then be cloned for implementation and subsequent configuration on ANY Raspberry model.

C) Dropping Pi-Star configuration backups from existing systems into the /boot directory 
  at this step makes this an easy why to migrate to better hardware (uSD's and Pi4's) at the 
  same time.


---

kn2tod (@arrl.net)
mark
 



