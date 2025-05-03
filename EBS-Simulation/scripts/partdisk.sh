#!/bin/bash

 source ./err_log.sh
 source ./succ_log.sh

 DISK=$1 
 PART_SIZE=$2
 FORMAT=$3
 MOUNT_DIR=$4
 

 ###################################
 #            FUNCTIONS            #                                
 ###################################
 
 function convert_size_to_MiB() {
    local VALUE=$(echo "$PART_SIZE" | sed 's/[^0-9]//g')
    local UNIT=$(echo "$PART_SIZE" | sed -E 's/[0-9]+//g'| tr '[:lower:]' '[:upper:]')
    local FULL_SIZE=$(lsblk -bdnro SIZE "$DISK")
    local FULL_SIZE_MIB=$((FULL_SIZE / 1024 / 1024)) 

    if [ "$UNIT" == 'G' ] || [ "$UNIT" == 'GB' ]; then
       VALUE=$((VALUE * 1024))

       if [ "$VALUE" -eq "$FULL_SIZE_MIB" ]; then   
	       VALUE=$((VALUE - 2))
       fi 
    fi

    echo $VALUE
 }
 
 function create_gpt_ifneeded(){
     if ! parted -s $DISK print | grep -q "Partition Table: gpt"; then
          parted $DISK mklabel gpt
	  succ_log "GPT table created for disk: $DISK"
     fi  
 }
 
 function get_free_space_info(){
     START_MIB=$(parted -s $DISK unit MiB print free | awk '/Free Space/ {print $1}' | tail -n 1 | sed 's/MiB//')
     START_MIB=$(printf "%.0f" "$START_MIB")
     TOTAL_MIB=$(parted -s $DISK unit MiB print free | awk '/Free Space/ {print $3}' | tail -n 1 | sed 's/MiB//')
     TOTAL_MIB=$(printf "%.0f" "$TOTAL_MIB")
 }

 ######################################
 #            MAIN PROGRAM            #             
 ######################################

 if [ -z "$DISK" ] || [ -z "$PART_SIZE" ] || [ -z "$FORMAT" ] || [ -z "$MOUNT_DIR" ]; then
    err_log "Usage- $0 <disk_path> <partition_size> <format_type> <mount_directory>"
    exit 1
 fi
 
 if [ "$FORMAT" != 'ext4' ] && [ "$FORMAT" != 'xfs' ]; then
    err_log "Error: Format type must be ext4 or xfs."
    exit 1
 fi

 SIZE_MIB=$(convert_size_to_MiB $PART_SIZE) 
 create_gpt_ifneeded	
 get_free_space_info
 
 if [ "$RESIZE_EXISTING" == "true" ]; then
    bash resize_part.sh $DISK
 fi

 if [ "$TOTAL_MIB" -lt "$SIZE_MIB" ]; then 
    err_log "Not enough free space. Requested: $SIZE_MIB MiB, Available: $TOTAL_MIB MiB."
    err_log "Please run 'vagrant halt', increase the disk size in VirtualBox settings, then 'vagrant up' again and re-run this script.\
\nIf you want to resize the existing partition, re-run the script like: RESIZE_EXISTING=true ./partdisk.sh <disk> 0 <format> <mountpoint>.\
\nIf not, simply re-run: ./partdisk.sh <disk> <partition_size> <format> <mountpoint>."
    exit 1
 fi 
 
 bash alignment.sh $DISK $FORMAT $SIZE_MIB $START_MIB $MOUNT_DIR

