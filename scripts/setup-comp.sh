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

# Update networking on computes
# ifconfig eno8403 10.0.0.2/16 netmask 255.255.0.0
#
# The above command also adds this 
# ip route add 10.0.0.0/16 netmask 255.255.0.0
#
# ip route add default via 10.0.0.1 dev eno8403

# Mounting filesystems 
#
# add to /etc/fstab
#
# nfs mounts provided in warewulf.conf
# 10.0.0.1:/home /home nfs defaults 0 0
# 10.0.0.1:/projects /projects nfs defaults 0 0
#

# change permissions
chmod u+x /usr
chmod g+x /usr
chmod o+x /usr

# turn things back on 
set -x
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
