#!/bin/bash
# @ryan
# Compute node image is stuck with incorrect permissions,
# I'm not sure what is setting them but this is just easier
# to copy over and run.
#
# I want to transfer this to an ansible playbook at some point

echo -=-=-=-=-=-=-=-=-
echo "Set IP Address"
echo -=-=-=-=-=-=-=-=-

set -x

if [[ "$1" == "2" ]]; then
    ifconfig eno8403 10.0.0.2/16 netmask 255.255.0.0
    ip route add default via 10.0.0.1 dev eno8403
elif [[ "$1" == "3" ]]; then
    ifconfig eno8403 10.0.0.3/16 netmask 255.255.0.0
    ip route add default via 10.0.0.1 dev eno8403
else
    echo "No network setup.."
fi

# Update networking on computes
# The above command also adds this
# ip route add 10.0.0.0/16 netmask 255.255.0.0

mkdir /opt
chown root:systems /opt/spack
mkdir /projects
chown root:systems /projects

# Mounting filesystems
# Add to /etc/fstab
mount -a

# Change permissions
chmod u+x /usr
chmod g+x /usr
chmod o+x /usr

chmod u+x /etc/slurm
chmod g+x /etc/slurm
chmod o+x /etc/slurm

# Restart services
systemctl restart dbus-broker
systemctl restart dbus
systemctl restart rtkit-daemon
systemctl restart wwclient
systemctl restart munge
systemctl restart slurmd
mount -a

set +x

echo "!!!"
echo "If you still can't ping things, you probably need to run this on the head node:"
echo "iptables -t nat -A POSTROUTING -o eno8303 -j MASQUERADE"
echo "!!!"

echo "Done :)"
