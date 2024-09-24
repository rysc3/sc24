#!/bin/bash 
# @ryan 
# Script to continuously update munge things as I'm debugging 
# Munge sucks 

echo check chrony:
chronyc tracking | grep "Leap status"

echo /etc/munge
chown munge:munge /etc/munge
chmod 0700 /etc/munge

echo /var/lib/munge
chown munge:munge /var/lib/munge
chmod 0711 /var/lib/munge

echo /var/log/munge
chown munge:munge /var/log/munge
chmod 0700 /var/log/munge

echo /run/munge
chown munge:munge /run/munge
chmod 0755 /run/munge

echo /usr/local/sbin/munged
# cp /usr/sbin/munged /usr/local/sbin/munged
# chown munge:munge /usr/local/sbin/munged
chmod 0755 /usr/local/sbin/munged





# Now it works!
systemctl daemon-reload
systemctl restart munge
systemctl status munge
