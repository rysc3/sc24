#!/bin/bash

#SBATCH --job-name=mlperf-inference
#SBATCH -p full
#SBATCH -w rr1
#SBATCH --cpus-per-task=120
#SBATCH --output=/projects/MLPerf/output_logs/mlperf_%j.out
#SBATCH --error=/projects/MLPerf/error_logs/mlperf_%j.err
#SBATCH --time=6:00:00

ROOT=/projects/MLPerf

docker run --name mlperf_nvidia_$SLURM_JOB_ID \
	--runtime=nvidia --gpus=all \
	-v $ROOT/scripts:/home/cmuser/scripts \
	8dbe5b6f9e93 \
	/home/cmuser/scripts/nvidia/offline-base.sh

docker logs mlperf_nvidia_$SLURM_JOB_ID > $ROOT/mlperf-logs/nvidia_$SLURM_JOB_ID.log
