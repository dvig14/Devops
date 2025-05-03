# AWS EBS Simulation using Shell Scripting (DevOps Project)

This project simulates **AWS EBS volume creation, formatting, and mounting** operations using shell scripts, enabling automation for disk partitioning similar to provisioning EBS volumes in AWS.

## 🔧 Features

- Create GPT partitions automatically
- Support for `ext4` and `xfs` file systems
- Format and mount partitions safely
- Automatic detection of mount issues
- Optional resizing of existing partitions (like EBS resizing)
- Logging via custom success and error handlers

## 📁 Directory Structure

- `scripts/` - Contains all bash scripts
- `examples/` - Sample executions and logs

## 🚀 Usage

```bash
# Basic usage
cd scripts
./partdisk.sh /dev/sdX 10G ext4 /mnt/myvol

# Resize existing
cd scripts
RESIZE_EXISTING=true ./partdisk.sh /dev/sdX 0 ext4 /mnt/myvol

