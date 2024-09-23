#!/bin/bash 

scp /etc/munge/munge.key rr2:/etc/munge/munge.key
scp /run/munge/munged.pid rr2:/run/munge/munged.pid
scp /var/run/munge/munged.pid rr2:/var/run/munge/munged.pid
scp /etc/systemd/system/munge.service.d/override.conf rr2:/etc/systemd/system/munge.service.d/override.conf
