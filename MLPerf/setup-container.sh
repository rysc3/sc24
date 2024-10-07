#!/bin/bash 

source /projects/ryan/MLPerf/cm/bin/activate

cm run script --tags=run-mlperf,inference,_find-performance,_r4.1-dev,_short,_scc24-base \
	      --model=sdxl \
	      --implementation=nvidia \
	      --framework=tensorrt \
	      --category=datacenter \
	      --scenario=Offline \
	      --execution_mode=test \
	      --device=cuda \
	      --docker-arg="--rm=false" \
	      --docker \
	      --quiet \
	      --env.CM_CACHE=/projects/ryan/.cm/cach \
	      --env.CM_MLPERF_MODEL_SDXL_DOWNLOAD_TO_HOST=yes \
	      --env.CM_MLPERF_MODEL_SDXL_DOWNLOAD=yes
