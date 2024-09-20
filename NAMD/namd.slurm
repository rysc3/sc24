#!/bin/bash

#SBATCH -N 1
#SBATCH -p full
#SBATCH -w rr1
#SBATCH --ntasks 4
#SBATCH --exclusive

export NAMD_TAG=3.0-beta5
export INPUT_FILE=/host_pwd/apoa1/apoa1_nve_cuda_soa.namd
export NAMD_EXE=namd3

export HOMEBIND=/projects/NAMD3:/host_pwd
export SIMG=/projects/NAMD3/namd3.img

# ${SINGULARITY} ${NAMD_EXE} +p2 +devices 0,1 +setcpuaffinity {input_file}

srun singularity run --nv -B $HOMEBIND $SIMG ${NAMD_EXE} +p4 +devices 0,1,2,3 +setcpuaffinity /host_pwd/data/apoa1/apoa1.namd
