#!/bin/bash

#SBATCH --job-name=mlperf-inference
#SBATCH -p full
#SBATCH -w rr1
#SBATCH --cpus-per-task=200
#SBATCH --output=/projects/MLPerf/output_logs/mlperf_%j.out
#SBATCH --error=/projects/MLPerf/error_logs/mlperf_%j.err
#SBATCH --time=6:00:00

ROOT=/projects/MLPerf

SCRIPT=$1

if [ -z "$SCRIPT" ]; then
  echo "Error: No script provided to run."
  echo $SCRIPT
  exit 1
fi

docker start mlperf-nvidia3

docker exec mlperf-nvidia3 /home/cmuser/scripts/nvidia/$SCRIPT

docker logs mlperf-nvidia3 > $ROOT/mlperf-logs/nvidia_$SLURM_JOB_ID.log
