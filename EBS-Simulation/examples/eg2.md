# Example 2: Partitioning and Mounting `/dev/sdc`

This example demonstrates the process of creating a new partition on `/dev/sdc`, formatting it with `ext4`, and attempting to mount it using a shell script. It includes command outputs, alignment checks, and log entries from the process.

---


## ✅ Before Partitioning
 
### `lsblk` Output:
```bash
root@AWS:/AWS/EBS-Simulation/scripts# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0    7:0    0 63.8M  1 loop /snap/core20/2501
...
...
sda      8:0    0   40G  0 disk
└─sda1   8:1    0   40G  0 part /
sdb      8:16   0   10M  0 disk
sdc      8:32   0    5G  0 disk
sdd      8:48   0   30G  0 disk
└─sdd1   8:49   0   20G  0 part /mnt/data
```

### `Alignment` Output:
```bash 
root@AWS:/AWS/EBS-Simulation/scripts# parted -s /dev/sdc unit mib print free
Model: VBOX HARDDISK (scsi)
Disk /dev/sdc: 5120MiB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start    End      Size     File system  Name  Flags
        0.02MiB  5120MiB  5120MiB  Free Space
```


## Run
```bash
root@AWS:/AWS/EBS-Simulation/scripts# ./partdisk.sh /dev/sdc 5g ext4 /mnt/data
```


## ✅ After Partitioning

### `lsblk` Output:
```bash
root@AWS:/AWS/EBS-Simulation/scripts# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0    7:0    0 63.8M  1 loop /snap/core20/2501
...
...
sda      8:0    0   40G  0 disk
└─sda1   8:1    0   40G  0 part /
sdb      8:16   0   10M  0 disk
sdc      8:32   0    5G  0 disk
└─sdc1   8:33   0    5G  0 part
sdd      8:48   0   30G  0 disk
└─sdd1   8:49   0   20G  0 part /mnt/data
```
### ⚠️ Note
`/dev/sdc1` was created successfully, but it was **not mounted** because `/mnt/data` is already in use by `/dev/sdd1`.

### `Alignment` Output:
```bash
root@AWS:/AWS/EBS-Simulation/scripts# parted -s /dev/sdc unit mib print free
Model: VBOX HARDDISK (scsi)
Disk /dev/sdc: 5120MiB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start    End      Size     File system  Name     Flags
        0.02MiB  1.00MiB  0.98MiB  Free Space
 1      1.00MiB  5119MiB  5118MiB  ext4         primary
        5119MiB  5120MiB  0.98MiB  Free Space
```


## Logs 

### Error:
```bash
root@AWS:/AWS/EBS-Simulation/scripts# cat ../logs/error.log
2025-04-20 14:10:46 - ERROR: Usage- ./partdisk.sh <disk_path> <partition_size> <format_type> <mount_directory>
2025-05-03 18:24:10 - ERROR: /dev/sdd1 already formatted with ext4. Skipping mkfs.
2025-05-03 18:48:11 - ERROR: Not enough free space. Requested: 20480 MiB, Available: 10239 MiB.
...
...
...
2025-05-03 20:11:21 - ERROR: Mul Vols ( /dev/sdd1, /dev/sdc1 ) cant have same mount point i.e /mnt/data
```
 
### Success:
```bash 
root@AWS:/AWS/EBS-Simulation/scripts# cat ../logs/success.log
...
...
2025-05-03 19:41:46 - SUCCESS: /dev/sdc partition created of size 5118
2025-05-03 19:41:48 - SUCCESS: /dev/sdc1 formated at filesys ext4
2025-05-03 20:11:19 - SUCCESS: /dev/sdc partition created of size 5118
2025-05-03 20:11:21 - SUCCESS: /dev/sdc1 formated at filesys ext4
``` 
