#!/bin/bash
#SBATCH --job-name=icon_docker_job           # Job name
#SBATCH --ntasks=112                           # Number of MPI tasks
#SBATCH --cpus-per-task=2
#SBATCH --time 1-00:00:00                   # Time limit days:hrs:min:sec
#SBATCH --partition=full
#SBATCH -w rr1

srun docker run --rm -v /projects/ryan/icon/icon-7/icon-model:/home/icon/icon -w /home/icon/icon/run icon-10.19.2024 ./exp.nh_dcmip_tc_52_r2b4.run 
