#!/bin/bash 

# @ryan 
# similar to the one given by I'm copying the nvidia version from:
# https://docs.mlcommons.org/inference/benchmarks/text_to_image/sdxl/#__tabbed_23_2 


cm run script --tags=run-mlperf,inference,_find-performance,_full,_r4.1-dev \
   --model=sdxl \
   --implementation=nvidia \
   --framework=tensorrt \
   --category=datacenter \
   --scenario=Offline \
   --execution_mode=test \
   --device=cuda  \
   --docker --quiet \
   --test_query_count=50
