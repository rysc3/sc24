#!/bin/bash 

if [ "$#" -ne 1 ]; then 
  echo "wrong usage"
  exit 1
fi

IN=$1

{
  echo "data =["
  while IFS=, read -r node score; do 
    echo "    (\"${node//[[:space:]]/}\", \"${score//[[:space:]]/}\"),"
  done < "$IN"
  echo "]"
}