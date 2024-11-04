#!/bin/bash

cm run script --tags=run-mlperf,inference,_r4.1-dev,_short,_scc24-main \
   --model=sdxl \
   --implementation=nvidia \
   --framework=tensorrt \
   --category=datacenter \
   --scenario=Offline \
   --execution_mode=fast \
   --device=cuda \
   --batch_size=8 \
   --precision=float16 \
   --hw_name="single_node_dell_poweredge_4xH100_NVL" \
   --mode=performance \
   --quiet
