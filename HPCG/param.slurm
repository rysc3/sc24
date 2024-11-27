# Blame @Ryan Scherbarth
# https://ryanscherbarth.com
# https://github.com/rysc3/sc24

#!/bin/bash 
#SBATCH --job-name "HPCG"
#SBATCH --time 04:01:00
#SBATCH -N 2
#SBATCH --ntasks-per-node 4 	# HPL requires 1 MPI rank for each gpu 
#SBATCH --array 1-2
#SBATCH -w hops1,hops2
#SBATCH --partition admin
#SBATCH --account 

#
# Start Static Variables
#
START_TIME=`date "+%Y-%m-%dT::%H:%M:%S"`
# CONT='/ascldap/users/rdscher/nvidia/hpc-benchmarks:24.06.sif'
CONT='/ascldap/users/rdscher/nvidia/hpc-benchmarks:24.03.sif'
MOUNT="/ascldap/users/rdscher/HPCG:/workspace/dat-files"
RESULTS_FULL="$SLURM_SUBMIT_DIR/RESULTS_FULL.csv"
RESULTS_SML="$SLURM_SUBMIT_DIR/RESULTS_SML.csv"
PARAMS_FILE="$SLURM_SUBMIT_DIR/PARAM_PARAMS.csv"
TEMPLATE_FILE="$SLURM_SUBMIT_DIR/HPCG_TEMPLATE.dat"
#
#


#
## Check dependencies exist 
if test -f $PARAMS_FILE; then 
  echo Params file: [ $PARAMS_FILE ]
else 
  echo Params file not found: [ $PARAMS_FILE ]
  exit 1
fi
# if test -f $TEMPLATE_FILE; then 
#   echo Template File: $TEMPLATE_FILE
# else 
#   echo Template File not found: [ $TEMPLATE_FILE ]
#   exit 1
# fi
if test -f $RESULTS_FULL; then 
  echo Results Full: [ $RESULTS_FULL ]
else 
  echo Results Full not found: [ $RESULTS_FULL ]
  exit 1
fi
if test -f $RESULTS_SML; then 
  echo Results Small: $RESULTS_SML
else 
  echo Results Small not found: [ $RESULTS_SML ]
  exit 1
fi
# 


#
## Get line from template based off of array id
#
PARAMS=$(head -n $SLURM_ARRAY_TASK_ID $PARAMS_FILE | tail -n 1)
#
## Now get each individual param from the param line 
#
echo "Running job: $SLURM_JOB_ID"
NX=$(echo $PARAMS | awk -F", " '{print $1}')
echo Read NX Value: $NX
#
NY=$(echo $PARAMS | awk -F", " '{print $2}')
echo Read NY Value: $NY
#
NZ=$(echo $PARAMS | awk -F", " '{print $3}')
echo Read NZ Value: $NZ
#
RT=$(echo $PARAMS | awk -F", " '{print $4}')
echo Read RT Value: $RT
#
# SWP=$(echo $PARAMS | awk -F", " '{print $5}')
# echo Read Swap Value: $SWP
#

#
## Other Parameters 
#



#
# Create a new working directory for each HPL run. We need to do this
# Since each runs off of it's own HPL.dat file. We can leave the HPL.dat 
# files there afterward as well to make it easier to go back and review 
# legacy runs. 
#
TMP_DIR=$(mktemp --directory -p $SLURM_SUBMIT_DIR/full-job-output)
WORK_DIR=$(basename $TMP_DIR)
#
# Echo temp dir so we can find in the slurm output 
#
echo Made temp dir: [ $TMP_DIR ]
echo Saved work dir: [ $WORK_DIR ]
#
# cd into new temp dir
#
cd $TMP_DIR
#
# echo cd into tmp dir
#
cp $TEMPLATE_FILE $TMP_DIR/hpcg.dat
# echo Copied template file to temp dir
#
## Replace variables in HPL.dat from param sweep
#
echo "-----"
# sed -i "s/<TMP_nx>/$nx/g" hpcg.dat
# echo Replaced Template nx with: $nx
# sed -i "s/<TMP_ny>/$ny/g" hpcg.dat
# echo Replaced Template ny with: $ny
# sed -i "s/<TMP_nz>/$nz/g" hpcg.dat
# echo Replaced Template nz with: $nz
sed -i "3s/.*/$NX $NY $NZ/" hpcg.dat
echo replaced hpcg.dat dimensions: $NX $NY $NZ
sed -i "4s/.*/$RT/" hpcg.dat
echo replaced hpcg.dat running time: $RT
echo "-----"
#


#
# #
# # # Run HPL
# #
#
OUTPUT=$TMP_DIR/HPCG.out

echo Redirecting HPCG output to: $OUTPUT
echo Start time: $START_TIME

# cuda version in singularity container is 12.3.107
# cuda version on compute nodes is 12.5
srun --mpi=pmi2 singularity run \
  --nv -B $MOUNT $CONT \
  $SLURM_SUBMIT_DIR/hpcg.sh \
  --nx $NX \
  --ny $NY \
  --nz $NZ \
  --rt $RT \
  >> $OUTPUT
#
# #
# # # Run HPL
# #
#


END_TIME=`date "+%Y-%m-%dT::%H:%M:%S"`

echo End time: $END_TIME


#
# Handle Result 
# 
# First grep returns: 
#
#
# Gflops : Rate of execution for solving the linear system.
# 
# The following parameter values will be used:
#
# Final Summary=
# Final Summary::HPCG result is VALID with a GFLOP/s rating of=1090.04
# Final Summary::HPCG 2.4 rating for historical reasons is=1219.08
# Final Summary::Results are valid but execution time (sec) is=29.8181
# Final Summary::Official results execution time (sec) must be at least=1800
#

GFLOPS_LINE=$(grep --after 2 Gflops $OUTPUT)
# echo GLOPS LINE: $GFLOPS_LINE
GFLOPS=$(cat $OUTPUT | grep GFLOP/s | tail -n 1 | awk -F= '{print $NF}')
#
#
echo "-----------Results-----------"
echo GFLOPS: $GFLOPS
echo "-----------------------------"
#
#
echo Saving results to files..
#
# #
# # Push to Results Full
# #
#
echo "--------------------" >> $RESULTS_FULL
echo --nodes: $SLURM_JOB_NUM_NODES >> $RESULTS_FULL
echo --ntasks-per-node: $SLURM_TASKS_PER_NODE >> $RESULTS_FULL 
echo Nodelist: $(squeue -j $SLURM_JOB_ID | tail -n 1 | awk -F" " '{print $NF}') >> $RESULTS_FULL
echo Params: NX, NY, NZ, RT >> $RESULTS_FULL 
echo $NX, $NY, $NZ, $RT >> $RESULTS_FULL 
echo -- Results -- >> $RESULTS_FULL
echo GFlops: $GFLOPS >> $RESULTS_FULL
echo Start time: $START_TIME >> $RESULTS_FULL
echo End time: $END_TIME >> $RESULTS_FULL
echo "--------------------" >> $RESULTS_FULL
# 
# #
# # Push to Results Sml
# #
#
echo $NX, $NY, $NZ, $RT, $GFLOPS >> $RESULTS_SML
#
# #
# # Format results for NB Graph
# #
#
# echo $NB, $GFLOPS >> $SLURM_SUBMIT_DIR/GRAPH_NB.csv
#
# #
# # Format results for P,Q Graph
# #
#
# echo $NB, $P, $Q, $GFLOPS >> $SLURM_SUBMIT_DIR/GRAPH_NB_PQ.csv
#
# #
# # Format results for N Graph
# #
# 
# echo $NB, $N, $GFLOPS >> $SLURM_SUBMIT_DIR/GRAPH_N.csv
#
# #
# # Format results for SWAP
# #
#
# echo $SWP, $GFLOPS >> $SLURM_SUBMIT_DIR/GRAPH_SWAP.csv
#
# # 
# # Format for individual node check 
# # 
#
# echo "$(hostname), $GFLOPS" >> $SLURM_SUBMIT_DIR/RESULTS_IND.csv
#
# #
# # Format for individual gpu check 
# #
#
# echo "$(hostname)[$GPU_INDEX], $GFLOPS">> $SLURM_SUBMIT_DIR/RESULTS_IND.csv


echo Done.
