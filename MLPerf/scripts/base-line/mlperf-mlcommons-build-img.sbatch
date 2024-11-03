#!/bin/bash

#SBATCH --job-name=mlperf-inference
#SBATCH -p full
#SBATCH -w rr1
#SBATCH --cpus-per-task=120
#SBATCH --output=/projects/MLPerf/output_logs/mlperf_%j.out
#SBATCH --error=/projects/MLPerf/error_logs/mlperf_%j.err
#SBATCH --time=3:00:00

ROOT=/projects/MLPerf

source $ROOT/cm-venv/bin/activate

cm run script --tags=run-mlperf,inference,_find-performance,_r4.1-dev,_short,_scc24-base \
   --model=sdxl \
   --implementation=reference \
   --framework=pytorch \
   --category=datacenter \
   --scenario=Offline \
   --execution_mode=test \
   --device=cuda  \
   --docker --quiet \
   --precision=float16
