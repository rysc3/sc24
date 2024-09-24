#!/bin/bash
# @ryan 
# Script to make a backup of the entire OS 
# in case things go horribly wrong 

sudo dd if=/dev/nvme0n1 bs=64K conv=noerror,sync status=progress | gzip > Backup-9.23.24.img.gz
