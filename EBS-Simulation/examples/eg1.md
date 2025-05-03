## Example Workflow : /dev/sdd

### Before Partitioning:

 First, let's check the current disk layout using `lsblk`:

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
 └─sdc1   8:33   0    2G  0 part
 sdd      8:48   0   30G  0 disk
 ```

### Run Script:
 
 ``` bash 
 root@AWS:/AWS/EBS-Simulation/scripts# ./partdisk.sh /dev/sdd 20g ext4 /mnt/data
 Partition /dev/sdd1 created and mounted at /mnt/data
 ```

### After Partition:
 
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
 └─sdc1   8:33   0    2G  0 part
 sdd      8:48   0   30G  0 disk
 └─sdd1   8:49   0   20G  0 part /mnt/data
 ```

### Partition mounted correctly:
 
 ```bash 
 root@AWS:/AWS/EBS-Simulation/scripts# mount | grep /dev/sdd1
 /dev/sdd1 on /mnt/data type ext4 (rw,relatime)
 ```
