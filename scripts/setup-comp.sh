#!/bin/bash 

# Update networking on computes
ifconfig eno8403 10.0.0.2/16 netmask 255.255.0.0
ip route add 10.0.0.0/16 netmask 255.255.0.0
ip route add default via 10.0.0.1 dev eno8403

# change permissions
chmod u+x /usr
chmod g+x /usr
chmod o+x /usr

