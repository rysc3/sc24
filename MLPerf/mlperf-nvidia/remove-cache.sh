#!/bin/bash 
# @ryan 

# Remove cache so you can actually run again. 
# This should not be done until ~/generate-submission-tree.sh 
# and ~/submit-results.sh have been run successfully, or else 
# everything will be gone. 

# cm show cache --tags=results,dir,local -j
CACHE="$(cm show cache --tags=results,dir,local -j | tail -n 1 | awk '{print $2}')"



if [ "$1" == "yes" ]; then
  echo "Deleting cache: $CACHE"
  rm -rf $CACHE
else 
  echo "if you haven't pushed, things will go bad."
  echo "run ~/generate-results-tree.sh"
  echo "then run ~/submit-results.sh"
  echo "then go to the link from submit and tell ryan to create a pull req."
  echo "then run this again with ~/remove-cache.sh yes"
fi
