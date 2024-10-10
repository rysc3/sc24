#!/bin/bash 
# @ryan
#
# I don't waant to actually install more on the compute 
# image so I will do this manually since we intend to 
# switch to singularity images soon anyway

yum config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl start docker
systemctl start docker.socket
