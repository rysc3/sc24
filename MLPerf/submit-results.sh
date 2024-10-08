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


# HTTPS submit 
# FORK_URL="https://github.com/rysc3/cm4mlperf-inference"
# SSH submit 
FORK_URL="git@github.com:rysc3/cm4mlperf-inference.git"

# cm run script --tags=push,github,mlperf,inference,submission \
#    --repo_url=https://github.com/rysc3/cm4mlperf-inference \
#    --repo_branch=mlperf-inference-results-scc24 \
#    --commit_message="Results on system UNM Roadrunners" \
#    --quiet

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

echo "If things broke, you probably need to do a rebase here: /home/ryan/CM/repos/local/cache/85ebe7ead4c64782/repo"
