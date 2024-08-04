#!/bin/bash 
#SBATCH --job-name "HPL Ns"
#SBATCH --time 04:01:00
#SBATCH -N 60
#SBATCH --ntasks-per-node 4 	# HPL requires 1 MPI rank for each gpu 
#SBATCH --array 1-50
#SBATCH --partition admin
#SBATCH --account FY140198

# export NVSHMEM_BOOTSTRAP_PMI=PMIX
# export HPL_USE_NVSHMEM=0
# export NCCL_NET_GDR_LEVEL=LOC

# @ryan use this for individual-gpu.sh
# export CUDA_VISIBLE_DEVICES=${GPU_INDEX}

#
# Start Static Variables
#
START_TIME=`date "+%Y-%m-%dT::%H:%M:%S"`
# CONT='/ascldap/users/rdscher/nvidia/hpc-benchmarks:24.06.sif'
CONT='/ascldap/users/rdscher/nvidia/hpc-benchmarks:24.03.sif'
MOUNT="/ascldap/users/rdscher/HPL:/workspace/dat-files"
RESULTS_FULL="$SLURM_SUBMIT_DIR/RESULTS_FULL.csv"
RESULTS_SML="$SLURM_SUBMIT_DIR/RESULTS_SML.csv"
PARAMS_FILE="$SLURM_SUBMIT_DIR/PARAM_PARAMS.csv"
TEMPLATE_FILE="$SLURM_SUBMIT_DIR/HPL_TEMPLATE.dat"
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
if test -f $TEMPLATE_FILE; then 
  echo Template File: $TEMPLATE_FILE
else 
  echo Template File not found: [ $TEMPLATE_FILE ]
  exit 1
fi
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
NB=$(echo $PARAMS | awk -F", " '{print $1}')
echo Read NP_ROW Value: $NB
#
P=$(echo $PARAMS | awk -F", " '{print $2}')
echo Read NP_COL Value: $P
#
Q=$(echo $PARAMS | awk -F", " '{print $3}')
echo Read NP_ORDER Value: $Q
#
N=$(echo $PARAMS | awk -F", " '{print $4}')
echo Read N Value: $N
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
cp $TEMPLATE_FILE $TMP_DIR/HPL.dat
# echo Copied template file to temp dir
#
## Replace variables in HPL.dat from param sweep
#
echo "-----"
sed -i "s/<TMP_NB>/$NB/g" HPL.dat
echo Replaced Template NB with: $NB
sed -i "s/<TMP_P>/$P/g" HPL.dat
echo Replaced Template P with: $P
sed -i "s/<TMP_Q>/$Q/g" HPL.dat
echo Replaced Template Q with: $Q
sed -i "s/<TMP_N>/$N/g" HPL.dat
echo Replaced Template N with: $N
# sed -i "s/<TMP_SWP>/$SWP/g" HPL.dat
# echo Replaced Template SWP with: $SWP
echo "-----"
#


#
# #
# # # Run HPL
# #
#
OUTPUT=$TMP_DIR/HPL.out

echo Redirecting HPL output to: $OUTPUT
echo Start time: $START_TIME

# cuda version in singularity container is 12.3.107
# cuda version on compute nodes is 12.5
srun --mpi=pmi2 singularity run --nv -B "${MOUNT}" "${CONT}" $SLURM_SUBMIT_DIR/hpl.sh --dat /workspace/dat-files/full-job-output/$WORK_DIR/HPL.dat >> HPL.out
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
# --
# T/V                N    NB     P     Q         Time          Gflops (   per GPU)
# --------------------------------------------------------------------------------
# WC0            99840   256     2     2         7.25       9.154e+04 ( 2.289e+04)
#

GFLOPS_LINE=$(grep --after 2 Gflops $OUTPUT)
# echo GLOPS LINE: $GFLOPS_LINE
GFLOPS=$(echo $GFLOPS_LINE | tail -n 1 | awk -F" " '{print $(NF-2)}')
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
echo Nodelist: $(squeue -j 33071 | tail -n 1 | awk -F" " '{print $NF}') >> $RESULTS_FULL
echo Params: NB, P, Q, N >> $RESULTS_FULL 
echo $NB, $P, $Q, $N >> $RESULTS_FULL 
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
echo $NB, $P, $Q, $N, $GFLOPS >> $RESULTS_SML
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
echo $NB, $N, $GFLOPS >> $SLURM_SUBMIT_DIR/GRAPH_N.csv
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
