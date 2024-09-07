#!/bin/bash


#SBATCH - N 1
#SBATCH -p debug
#SBATCH --ntasks-per-node 1
#SBATCH --mail-user rscherbarth@unm.edu 
#SBATCH --mail-type all

module load singularity

###  Before you run  ###
##                    ##
# You will need to copy the inputs & the scripts out of the singularity container;
#
# $ module load singularity
# $ singularity shell -B $PWD:/RYAN <path to .sif> 
# 
# You should now see Singularity> as your prompt
#
# $ cp -r /ae/inputs /RYAN
# $ cp -r /ae/scripts /RYAN
# $ exit
##
#######################


## Define things ##
# CONT=/users/rdscher/rep-sc24/dataflow_sc23.sif
CONT= # TODO: put the full filepath to your container here, perhaps $SLURM_SUBMIT_DIR/dataflow_sc23.sif

HOME_BIND=$SLURM_SUBMIT_DIR:/RYAN
# We need to bind the inputs so we have write access outside of the container.
INPUT_BIND=$SLURM_SUBMIT_DIR/inputs:/ae/inputs

# We run the script that we've copied to our home dir inside the singularity image through 
# the $HOME_BIND binding.
SCRIPT=/RYAN/scripts/run.sh

singularity run -B $HOME_BIND -B $INPUT_BIND $CONT $SCRIPT

#
