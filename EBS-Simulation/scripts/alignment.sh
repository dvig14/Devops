#!/bin/bash

 source ./err_log.sh
 source ./succ_log.sh

 DISK=$1
 FORMAT=$2
 SIZE_MIB=$3
 START_MIB=$4
 MOUNT_DIR=$5

 ##### Check if 1st partiition is created or not if not then align it , start sector must be 2048 ie is 1MB = 2048 sectors

 if [ "$START_MIB" -eq 0 ]; then
    START_MIB=1 # Ensure alignment
 fi
 END_MIB=$((START_MIB + SIZE_MIB))
 
 OLD_PART=$(lsblk -npro NAME $DISK)

 parted --align optimal $DISK mkpart primary $FORMAT ${START_MIB}MiB ${END_MIB}MiB 
 succ_log "$DISK partition created of size $SIZE_MIB"

 #### Refresh Table 
 partprobe $DISK
 sleep 1


 #### Check for new partition created 
 NEW_PART=$(lsblk -npro NAME $DISK)

 if [ "$NEW_PART" == "$OLD_PART" ] ; then
    err_log "Partition creation failed"
    exit 1
 fi

 PARTITION=$(lsblk -nrpo NAME,TYPE | awk -v disk="$DISK" '$2=="part" && $1 ~ disk {print $1}' | tail -n 1) 

 bash format-mount.sh $FORMAT $PARTITION $MOUNT_DIR 
 
