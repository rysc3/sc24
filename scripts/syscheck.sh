#!/bin/bash 
# @ryan 
# Script to start and verify all the dependencies
# and networking before booting compute nodes

echo ----------
echo "Network"
echo ----------
echo eno1
ip a | grep -A 5 ": eno8303"
echo eno2
ip a | grep -A 5 ": eno8403"
echo ----------
echo ----------


echo ----------
echo Starting Services
echo ----------
set -x # Echo each command as we run it
systemctl start --now warewulfd
systemctl start --now dhcpd
systemctl start --now tftp 
systemctl start --now nfs-server 
systemctl start --now nfs-mountd.service
systemctl start --now rpcbind.service 
systemctl start --now slurmd
systemctl start --now slurmctld
set +x # stop echoing commands


echo ----------
echo Daemons
echo ----------
echo Warewulf
systemctl status warewulfd --no-pager | grep Active:
echo DHCPD
systemctl status dhcpd | grep Active:
echo TFTP
systemctl status tftp | grep Active:
echo NFS
systemctl status nfs-server | grep Active:
systemctl status nfs-mountd.service | grep Active:
systemctl status rpcbind.service | grep Active:
echo Slurm
systemctl status slurmd | grep Active:
systemctl status slurmctld | grep Active:
echo ----------
echo ----------

# Update networking on computes
# ifconfig eno8403 10.0.0.3/16 netmask 255.255.0.0
# route add default gw 10.0.0.1 eno8403
# ip link set eno8403 up


# Potentially dangerous, breaks slurmd
# sudo iptables -t nat -A POSTROUTING -o eno8303 -j MASQUERADE
# sudo iptables-save | sudo tee /etc/sysconfig/iptables


# Manually mount:
# mount -t nfs 10.0.0.1:/home /home

# Manual Munge Start:
# /usr/sbin/munged --foreground --force

