#!/bin/bash 
# @ryan
# Compute node image is stuck with incorrect permissions,
# I'm not sure what is setting them but this is just easier
# to copy over and run.
#
# I want to transfer this to an ansible playbook at some point

echo -=-=-=-=-=-=-=-=-
echo set ip addr
echo -=-=-=-=-=-=-=-=-
set -x

# Update networking on computes
# ifconfig eno8403 10.0.0.2/16 netmask 255.255.0.0
#
# The above command also adds this 
# ip route add 10.0.0.0/16 netmask 255.255.0.0
#
# ip route add default via 10.0.0.1 dev eno8403

mkdir /opt
chown root:systems /opt/spack
mkdir /projects
chown root:systems /projects

# Mounting filesystems 
#
# add to /etc/fstab
#
# nfs mounts provided in warewulf.conf
# 10.0.0.1:/home /home nfs defaults 0 0
# 10.0.0.1:/projects /projects nfs defaults 0 0
# 10.0.0.1:/opt /opt nfs defaults 0 0
#
# Otherwise 
#
# mount -t 10.0.0.1:/opt /opt nfs defaults 0 0
#
mount -a
#

# change permissions
chmod u+x /usr
chmod g+x /usr
chmod o+x /usr

chmod u+x /etc/slurm
chmod g+x /etc/slurm
chmod o+x /etc/slurm

# turn things back on 
systemctl restart dbus
systemctl restart home.mount
systemctl restart rtkit-daemon
systemctl restart wwclient
systemctl restart upower
systemctl restart munge
systemctl restart slurmd
mount -a
set +x

echo "Done :)"
