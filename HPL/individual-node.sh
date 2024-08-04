#!/bin/bash 

# Script to loop over running HPL individually on each node to check for slow nodes 
# Pass in 1 int for an upper bound 
# Pass in 2 ints for a lower, upper range

#
# NB = 1184
# P, Q = 2
# N = 190000
#

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then 
  echo "One int for upper bound, or two ints to create a range"
  exit 1
fi

# Parse input
if [ "$#" -eq 1 ]; then 
  LOW=1
  HIGH=$1
else 
  LOW=$1
  HIGH=$2
fi

# Validate params 
if [ "$LOW" -gt "$HIGH" ]; then 
  echo "second param too small"
  exit 1
fi

# Schedule jobs
for (( i=$LOW; i<=$HIGH; i++ )); do 
  NODE="hops$i"
  echo "Node: ${NODE}"
  sbatch -w ${NODE} param.slurm
done
