#!/bin/bash 
# @ryan 
# Compute node image is stuck with incorrect permissions, 
# I'm not sure what is setting them but this is just easier 
# to copy over and run. 
#
# I want to transfer this to an ansible playbook at some point

# Update networking on computes
ifconfig eno8403 10.0.0.2/16 netmask 255.255.0.0
ip route add 10.0.0.0/16 netmask 255.255.0.0
ip route add default via 10.0.0.1 dev eno8403

# change permissions
chmod u+x /usr
chmod g+x /usr
chmod o+x /usr

