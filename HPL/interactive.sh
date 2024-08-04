#!/bin/bash 

export CONT='/ascldap/users/rdscher/nvidia/hpc-benchmarks:24.06.sif'
# export CONT='/ascldap/users/rdscher/nvidia/hpc-benchmarks:24.03.sif'
export MOUNT="$PWD:/workspace/dat-files"

echo "Running on hosts: $(echo $(scontrol show hostname))"

echo "-_-_-_-_-_-_-"
echo "-_-_-_-_-_-_-"
echo "srun --mpi=pmi2 singularity run --nv -B $ MOUNT $ CONT ./hpl.sh --dat /workspace/dat-files/HPL.dat"
echo "-_-_-_-_-_-_-"
echo "-_-_-_-_-_-_-"

