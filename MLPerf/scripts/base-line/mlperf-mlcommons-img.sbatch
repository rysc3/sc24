#!/bin/bash

#SBATCH --job-name=mlperf-inference
#SBATCH -p full
#SBATCH -w rr1
#SBATCH --cpus-per-task=120
#SBATCH --output=/projects/MLPerf/output_logs/mlperf_%j.out
#SBATCH --error=/projects/MLPerf/error_logs/mlperf_%j.err
#SBATCH --time=3:00:00

ROOT=/projects/MLPerf

docker run \
	--name mlperf_mlcommons_container_$SLURM_JOB_ID \
	--runtime=nvidia \
	--gpus=all \
	-v $ROOT/scripts:/home/cmuser/scripts \
	0bad1ddca493 \
	/home/cmuser/scripts/base-line/mlcommons-offline-base.sh

docker logs mlperf_mlcommons_container_$SLURM_JOB_ID > $ROOT/mlperf-logs/mlcommons_$SLURM_JOB_ID.log
