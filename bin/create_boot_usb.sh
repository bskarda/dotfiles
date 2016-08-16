diskutil list
 
read -p "Enter the name of the target USB stick (like disk1): " usbStick
 
if mount|grep "/dev/$usbStick"
then
    read -p "Are you sure USB Stick $usbStick is the good target? (y/n): " r
 
    if [ $r="y" ]
    then
        read -p "ISO file (with absolute path and without the extension): " iso
 
        if [ -f "$iso.iso" ]
        then
            hdiutil convert -format UDRW -o "$iso.img" "$iso.iso"
            diskutil unmountDisk /dev/$usbStick
            sudo dd if="$iso.img.dmg" of="/dev/r$usbStick" bs=1m
            diskutil eject /dev/$usbStick
            echo "Bootable USB stick created!"
         else
             echo "The ISO does not exist"
         fi
     fi
 
else
    echo "The USB flash drive you have chosen does not exist."
fi
