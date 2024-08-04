#!/bin/bash

if [-z "$1"]; then 
  echo "Pass input file"
  exit 1;
fi

IN=$1

nb_arr=()
flop_arr=()

# Fill Arrays
while IFS=, read -r nb flop; do 
  nb=$(echo "$nb" | xargs)
  flop=$(echo "$flop" | xargs)

  nb_arr+=("$nb")
  echo Filling NB Arr: $nb
  flop_arr+=("$flop")
  echo Filling Flop Arr: $flop
done < "$IN"

# Combine Arrays
combo=()
for i in "${!nb_arr[@]}"; do
  combo+=("${nb_arr[i]},${flop_arr[i]}")
  echo Filling Combo Arr: ${combo[i]}
done

# Sort combo array
echo Sorting Combo Arr...
IFS=$'\n' sorted=($(sort <<<"${combo[*]}"))

# Break up sorted 
sorted_nb=()
sorted_flop=()

for entry in "${sorted[@]}"; do 
  IFS=, read -r nb flop <<< "$entry"
  sorted_nb+=("$nb")
  echo Filling Sorted NB: $nb
  sorted_flop+=("$flop")
  echo Filling Sorted Flop: $flop
done

# Print
# echo "${sorted_nb[@]}"
# echo "${sorted_flop[@]}"

echo "${sorted_nb[@]}" | sed 's/ /, /g'
echo "${sorted_flop[@]}" | sed 's/ /, /g'


