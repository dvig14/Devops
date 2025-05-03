 #!/bin/bash

 source ./err_log.sh
 source ./succ_log.sh

 FORMAT=$1
 PARTITION=$2
 MOUNT_DIR=$3

 function check_mount_part(){
     
   # check partition is already mounted to some mount point
   MNT_PART=$(findmnt -n $PARTITION)

   if [[ -z $MNT_PART ]];then
	   UUID=$(blkid -s UUID -o value $PARTITION)

	   if [[ -z "$UUID" ]]; then
            err_log "Failed to fetch UUID for $PARTITION"
            exit 1
           fi

           grep -q "$UUID" /etc/fstab || echo "UUID=$UUID $MOUNT_DIR $FORMAT defaults 0 2" >> /etc/fstab
           mount -a
	   
	   if findmnt "$MOUNT_DIR" > /dev/null;then
		 echo "Partition $PARTITION created and mounted at $MOUNT_DIR"
                 succ_log "Partition $PARTITION created and mounted at $MOUNT_DIR"
	   else 
		 err_log "Failed to mount $PARTITION"
                 exit 1
	   fi
   else
	   err_log "Can mount mul mount pts to same vol but not safe as file locking issue and it must be done for read-only files or you can bind mount"
   fi
   
 }
 

 # Format type ext4 or xfs       
 wipefs -a $PARTITION
 mkfs.$FORMAT $PARTITION
 succ_log "$PARTITION formated at filesys $FORMAT"

 # Mount
  mkdir -p $MOUNT_DIR

 # Mul. vols can't have same mount point
 MPT_DISK=$( findmnt -n -o SOURCE $MOUNT_DIR )

 if [[ -z "$MPT_DISK" ]];then
         check_mount_part 
 elif [[ "$MPT_DISK" != "$PARTITION" ]];then
	 err_log "Mul Vols ( $MPT_DISK, $PARTITION ) cant have same mount point i.e $MOUNT_DIR"
         exit 1
 fi 

