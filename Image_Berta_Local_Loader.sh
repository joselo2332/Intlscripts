#!/bin/bash
#--------------------------------------------------
echo ""
echo ""
echo -e "\033[1mSelect the HDD to CLONE\033[0m"
sleep 1
echo ""
echo ""
sudo fdisk -l
echo ""
echo ""
echo -ne "\033[1m******                   (25%)\r\033[0m"
sleep 1
echo -ne "\033[1m************             (50%)\r\033[0m"
sleep 1
echo -ne "\033[1m******************       (75%)\r\033[0m"
sleep 1
echo -ne "\033[1m************************ (100%)\r\033[0m"
sleep 0
echo -ne '\n'
echo ""
echo ""
device_sda="/dev/sda"
device_sdb="/dev/sdb"
device_sdc="/dev/sdc"
device_sdd="/dev/sdd"
#--------------------------------------------------
           OPTIONS="sda sdb sdc sdd Quit"
           select opt in $OPTIONS; do
               if [ "$opt" = "Quit" ]; then
                echo done
                exit
               elif [ "$opt" = "sda" ]; then
                device=$device_sda
                break
               elif [ "$opt" = "sdb" ]; then
                device=$device_sdb
                break
               elif [ "$opt" = "sdc" ]; then
                device=$device_sdc
                break
               elif [ "$opt" = "sdd" ]; then
                device=$device_sdd
                break
               else
                clear
                echo Bad Option
               fi
           done
#--------------------------------------------------
ntfs_device=$device"1"
ext3_device=$device"1"
swap_device=$device"2"
berta_1=$device"1"
berta_2=$device"2"
berta_3=$device"3"
berta_4=$device"4"
berta_5=$device"5"
berta_6=$device"6"
#--------------------------------------------------
samba_share="//gmnap01vpga.zpn.intel.com/BertaOS/"
#--------------------------------------------------
samba_user="sys_bertagdc"
samba_pass="NetApp_1"
point_to_mount="/mnt/samba"
#--------------------------------------------------
echo "'"
echo "'"
echo -e "\033[1mHard Disk Partition Information\033[0m"
sudo fdisk $device -l
echo "'"
echo "'"
#--------------------------------------------------
echo "'"
echo "'"
echo -en '\E[47;31m'"\033[1mWARNING!!! This scrip will reboot the machine, please close all programs to continue !!!\033[0m"
echo "'"
echo "'"
#--------------------------------------------------
echo "'"
echo "'"
read -p "This scrip will erase all partitions of $device (y/n): " CONFIRM
#read CONFIRM
if [ $CONFIRM == y -o $CONFIRM == Y ]
then
  echo "You selected YES ---> Deleting Partitions"
elif [ $CONFIRM == n -o $CONFIRM == N ]
then
  echo "You selected NO ---> EXIT"
elif [ $CONFIRM != y -o $CONFIRM != Y -o $CONFIRM != n -o $CONFIRM != N ]
then
  exit 0
fi
echo "'"
echo "'"
#--------------------------------------------------
echo -e "\033[1mStart Mounting $samba_share\033[0m"
sudo mount -t cifs -o username=$samba_user -o passwd=$samba_pass $samba_share $point_to_mount "-v"
if [ $? -ne 0 ]; then
    echo "Mounting samba share failed. Check network."
    exit 1
fi
echo -e "\033[1mFinished Mount samba\033[0m"
#--------------------------------------------------
#Partition Table
echo ""
echo ""
sleep 1
echo -e "\033[1mSelect the System: \033[0m"
           OPTIONS="WINDOWS LINUX BERTA EXIT"
           select opt in $OPTIONS; do
               if [ "$opt" = "EXIT" ]; then
                echo done
                exit
               elif [ "$opt" = "WINDOWS" ]; then
                echo -e "\033[1mStart Windows Partition\033[0m"
                sudo fdisk $device < windows_partition_table.txt
                break
               elif [ "$opt" = "LINUX" ]; then
                echo -e "\033[1mStart Linux Partition\033[0m"
                sudo fdisk $device < linux_partition_table.txt
                break
               elif [ "$opt" = "BERTA" ]; then
                echo -e "\033[1mBerta Image Client\033[0m"
                sudo fdisk $device < berta_partition_table.txt
                break
               else
                clear
                echo Bad Option
               fi
           done
echo "'"
echo "'"
sudo partprobe -s $device
echo "'"
echo "'"
echo -e "\033[1mFinish Partition\033[0m"
echo "'"
echo "'"
#--------------------------------------------------
echo -e "\033[1mLoading Berta Image\033[0m"
echo "'"
echo "'"
berta_boot="OSTools/lx-boot-rhel-2011-10-21.img"
image_loader="OSTools/lx-rhel-imageloader-2011-11-30.img"
RHEL6_0="ProdOses/lx-rhel-s-6.0r-64-2013-10-10.img"
RHEL6_1="ProdOses/lx-rhel-s-6.1r-64-2013-10-10.img"
RHEL6_2="ProdOses/lx-rhel-s-6.2r-64-2013-10-10.img"
RHEL6_3="ProdOses/lx-rhel-s-6.3r-64-2013-10-10.img"
RHEL6_4="ProdOses/lx-rhel-s-6.4r-64-2013-10-10.img"
RHEL6_5="ProdOses/lx-rhel-s-6.5r-64-IOMMU-2013-11-21.img"
RHEL7_0="ProdOses/lx-rhel-s-7.0b-64-IOMMU-2013-12-16.img"
SUSE11_SP1="ProdOses/lx-sles-CrownPass-11.0-64-IOMMU-2013-07-30.img"
SUSE11_SP2="ProdOses/lx-sles-CrownPass-11.1-64-IOMMU-2013-07-30.img"
SUSE11_SP3="ProdOses/lx-sles-CrownPass-11.2-64-IOMMU-2013-07-30.img"
CENTOS_6_2="ProdOses/lx-centos-6.2-64-ofed-2012-07-09.img"
WINDOWS7="ProdOses/win7-64-CrownPass-2012-10-31.img.gz"
WINDOWS7_VS="ProdOses/win7-64-CrownPass-VS2012-2013-06-17.img.gz"
WINDOWS8="ProdOses/win8-64-CrownPass-2012-10-31.img.gz"
WINDOWS81="ProdOses/win8.1-64-CrownPass-2013-10-10.img.gz"
WINDOWS2012="ProdOses/win2012-r2-64-CrownPass-2013-10-10.img.gz"

echo "'"
echo "'"
#--------------------------------------------------
echo "'"
echo "'"
echo -e "\033[1mPlease Select the Operating System to Start:\033[0m"
echo "'"
echo "'"
#--------------------------------------------------
OPTIONS="RHEL6.0 RHEL6.1 RHEL6.2 RHEL6.3 RHEL6.4 RHEL6.5 RHEL7.0 SUSE11_SP1 SUSE11_SP2 SUSE11_SP3 CENTOS_6_2 Windows7 Windows7_VS Windows8 Windows8.1 Windows2012 BertaClient INFORMATION EXIT"
select opt in $OPTIONS; do
  if [ "$opt" = "INFORMATION" ]; then
    echo done
    echo This step clone the new Operation Systtem. 
    echo Please be patient. 
    echo Select other option:
#######################################################################################
#Linux_Images
  elif [ "$opt" = "RHEL6.0" ]; then
    echo Red Hat 6.0
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$RHEL6_0
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "RHEL6.1" ]; then
    echo Red Hat 6.1
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$RHEL6_1
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "RHEL6.2" ]; then
    echo Red Hat 6.2
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$RHEL6_2
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "RHEL6.3" ]; then
    echo Red Hat 6.3
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$RHEL6_3
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "RHEL6.4" ]; then
    echo Red Hat 6.4
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$RHEL6_4
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "RHEL6.5" ]; then
    echo Red Hat 6.5
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$RHEL6_5
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "RHEL7.0" ]; then
    echo Red Hat 7.0
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$RHEL7_0
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "SUSE11_SP1" ]; then
    echo SUSE SP1
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$SUSE11_SP1
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "SUSE11_SP2" ]; then
    echo SUSE SP2
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$SUSE11_SP2
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
  elif [ "$opt" = "SUSE11_SP3" ]; then
    echo SUSE SP3
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$SUSE11_SP3
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    breakext3_device
  elif [ "$opt" = "CENTOS_6_2" ]; then
    echo CENTOS 6.2
    sudo mkfs.ext3 $ext3_device
    sudo mkswap $swap_device
    sudo clone2fs -O $ext3_device $point_to_mount/$CENTOS_6_2
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo grub --no-floppy --batch < grub_batch_commands
    break
#######################################################################################
#Berta_Client
  elif [ "$opt" = "BertaClient" ]; then
    echo BertaClient
    sudo mkfs.ext3 $berta_1
    sudo mkfs.vfat $berta_2
    sudo mkfs.ntfs -f $berta_3
    sudo mkfs.ext3 $berta_5
    sudo mkswap $berta_6
    sudo dd if=$point_to_mount/$berta_boot of=$berta_2
    sudo clone2fs -O $berta_5 $point_to_mount/$image_loader
    echo -e "\033[1mGRUB COMMANDS ---> :)\033[0m"
    sudo mount $berta_2 /boot/
    grub-install $device_sda
    sudo umount /boot/
    break
#######################################################################################  
#windows_Images
  elif [ "$opt" = "Windows7" ]; then
    echo  win7-64-CrownPass-2012-10-31.img.gz
    sudo mkfs.ntfs -f $ntfs_device
    sudo gunzip -c $point_to_mount/$WINDOWS7 | ntfsclone -r -O $ntfs_device -
    break
  elif [ "$opt" = "Windows7_VS" ]; then
    echo  win7-64-CrownPass-VS2012-2013-06-17.img.gz
    sudo mkfs.ntfs -f $ntfs_device
    sudo gunzip -c $point_to_mount/$WINDOWS7_VS | ntfsclone -r -O $ntfs_device -
    break
  elif [ "$opt" = "Windows8" ]; then
    echo  win8-64-CrownPass-2012-10-31.img.gz
    sudo mkfs.ntfs -f $ntfs_device
    sudo gunzip -c $point_to_mount/$WINDOWS8 | ntfsclone -r -O $ntfs_device -
    break
  elif [ "$opt" = "Windows8.1" ]; then
    echo  win8.1-64-CrownPass-2013-10-10.img.gz
    sudo mkfs.ntfs -f $ntfs_device
    sudo gunzip -c $point_to_mount/$WINDOWS81 | ntfsclone -r -O $ntfs_device -
    break
  elif [ "$opt" = "Windows2012" ]; then
    echo  win2012-r2-64-CrownPass-2013-10-10.img.gz
    sudo mkfs.ntfs -f $ntfs_device
    sudo gunzip -c $point_to_mount/$WINDOWS2012 | ntfsclone -r -O $ntfs_device -
    break 
#######################################################################################
  elif [ "$opt" = "EXIT" ]; then
    break
  fi
done
#--------------------------------------------------
echo "Reboot in 3 Sec."
sleep 1
#sudo reboot
#--------------------------------------------------
