#!/bin/bash
# @ryan 
# Script to implement all the things from Matthew's 
# Slides: https://fricke.co.uk/Teaching/CS491_591_HPC_2024_Fall/Lectures/Lecture_15-Warewulf.pdf
# and a little bit from the slurm slides:
# https://fricke.co.uk/Teaching/CS491_591_HPC_2024_Fall/Lectures/Lecture_16-Slurm_Installation_and_Config.pdf

echo ============
echo Slide 75
echo ============
firewall-cmd --zone=external --add-interface=eno8303 --permanent
firewall-cmd --zone=internal --add-interface=eno8403 --permanent


echo ============
echo Slide 76
echo ============
firewall-cmd --set-default-zone=external


echo ============
echo Slide 77
echo ============
firewall-cmd --new-policy internal-external --permanent
firewall-cmd --policy internal-external --add-ingress-zone=internal --permanent
firewall-cmd --policy internal-external --add-egress-zone=external --permanent
firewall-cmd --policy internal-external --set-target=ACCEPT --permanent


echo ============
echo Slide 79
echo ============
firewall-cmd --zone internal --add-service warewulf --permanent
firewall-cmd --zone internal --add-service nfs --permanent
firewall-cmd --zone internal --add-service tftp --permanent
firewall-cmd --reload


echo ============
echo L16 Slurm Instillation
echo Slide 46
echo ============
firewall-cmd --permanent --zone=internal --add-port=6817/tcp
firewall-cmd --permanent --zone=internal --add-port=6819/tcp
firewall-cmd --reload
