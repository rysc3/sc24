#!/bin/bash 
#
# @ryan 
#
# Script to submit results from MLPerf
# @ryan 
#
# Script to submit results from MLPerf

#
# Submission Repo:
# https://github.com/gateoverflow/cm4mlperf-inference
#


FORK_URL="https://github.com/rysc3/cm4mlperf-inference"


echo "Starting cm submission at $(date)"
cm run script --tags=push,github,mlperf,inference,submission \
   --repo_url=$FORK_URL \
   --repo_branch=mlperf-inference-results-scc24 \
   --commit_message="Results on system UNM Roadrunners" \
   --quiet
echo "Finished cm submission at $(date)"


#
# https://github.com/mlcommons/cm4mlperf-inference/compare/mlperf-inference-results-scc24...rysc3:cm4mlperf-inference:mlperf-inference-results-scc24
#
echo ----------
echo /\/\/\/\/\
echo ----------
echo "Now go here and submit a pull request"
echo "https://github.com/mlcommons/cm4mlperf-inference/compare/mlperf-inference-results-scc24...rysc3:cm4mlperf-inference:mlperf-inference-results-scc24"
echo ----------
echo /\/\/\/\/\
echo ----------


#
# https://gateoverflow.github.io/cm4mlperf-inference
#
echo [][][][][]
echo -=-=-=-=-=
echo [][][][][]
echo "Now view the updated leaderboard here"
echo "https://gateoverflow.github.io/cm4mlperf-inference"
echo [][][][][]
echo -=-=-=-=-=
echo [][][][][]
