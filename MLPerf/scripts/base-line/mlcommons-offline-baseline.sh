#!/bin/bash

echo "==================================================="
echo "==================================================="
echo "==================================================="
echo "================= Base Variant ===================="
echo "==================================================="
echo "==================================================="
echo "==================================================="


cm run script --tags=run-mlperf,inference,_r4.1-dev,_short,_scc24-base \
   --model=sdxl \
   --implementation=reference \
   --framework=pytorch \
   --category=datacenter \
   --scenario=Offline \
   --execution_mode=test \
   --device=cuda \
   --quiet --precision=float16

echo "==================================================="
echo "==================================================="
echo "==================================================="
echo "================= Main Variant ===================="
echo "==================================================="
echo "==================================================="
echo "==================================================="

cm run script --tags=run-mlperf,inference,_r4.1-dev,_short,_scc24-main \
   --model=sdxl \
   --implementation=reference \
   --framework=pytorch \
   --category=datacenter \
   --scenario=Offline \
   --execution_mode=test \
   --device=cuda \
   --quiet --precision=float16
