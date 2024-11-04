#!/usr/bin/env bash

# This script is originally prepared from https://raw.githubusercontent.com/pegasus-isi/1000genome-workflow/master/prepare_input.sh
#
workdir=`pwd`

cd $workdir
for i in {1..10}
do
  gunzip -k ALL.chr${i}.250000.vcf.gz
done

cd $workdir
for i in {1..10}
do
  curl --output ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5.20130502.sites.annotation.vcf.gz ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/supporting/functional_annotation/filtered/ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5.20130502.sites.annotation.vcf.gz
  gunzip -k ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5.20130502.sites.annotation.vcf.gz
done

cd $workdir
