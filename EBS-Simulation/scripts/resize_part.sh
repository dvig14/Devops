#!/bin/bash

source ./err_log.sh
source ./succ_log.sh

DISK=$1

 function cmd_exist(){
   
   if ! command -v "$1" &>/dev/null; then
    
       local PACKAGE_NAME=""
       case "$1" in
          growpart)
              PACKAGE_NAME="cloud-guest-utils"
              ;;
          resize2fs)
              PACKAGE_NAME="e2fsprogs"
              ;;
          xfs_growfs)
              PACKAGE_NAME="xfsprogs"
              ;;
        esac

        err_log "Required command '$1' is missing. Please install it with:\n\nsudo apt-get update && sudo apt-get install -y $PACKAGE_NAME"
        exit 1
   
   fi

 }

 function resize_part(){
	
    local EXISTING_PART=$(lsblk -npro NAME,TYPE $DISK | awk '$2=="part" {print $1}' | tail -n 1)

    if [ -z "$EXISTING_PART" ]; then
       err_log "Can't resize as no partition exist. So simply run script to create partition: ./partdisk.sh <disk> <partition_size> <format> <mountpoint>."
       exit 1
    fi

   
   local PART_NUM="${$EXISTING_PART//[!0-9]/}"

    # Refresh table and Use parted to resize the partition
    cmd_exist growpart
    growpart $DISK $PART_NUM
    partprobe $DISK
    sleep 1

    
    # Get file sys type for resizing partition
    local FS_TYPE=$(blkid -o value -s TYPE $EXISTING_PART)

    if [ $FS_TYPE == "ext4" ]; then
          cmd_exist resize2fs
	  resize2fs "$EXISTING_PART"
    else
          local MOUNT_PT=$(findmnt -n -o TARGET $EXISTING_PART)

          if [ -n "$MOUNT_PT" ];then
                cmd_exist xfs_growfs
		xfs_growfs "$MOUNT_PT"
          else
                err_log "Can't resize partition $EXISTING_PART of File type (xfs) as not mounted."
                exit 1
          fi

    fi
       
    succ_log "$EXISTING_PART of FILE type $FS_TYPE is resized."
    exit 0
 }

 resize_part
