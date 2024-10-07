#!/bin/bash 
# @ryan 
# 
# Script to convert a docker container to singularity image 
# so that we can run multi-node. 


read -p "Cont ID: " CONTAINER_ID

# I'm saving the timestamp to make sure they're the same 
# since it will take some time to run the script and I 
# don't want the MM to vary
TIMESTAMP=$(date +"%m.%d-%H.%M")

DOCKER_IMAGE_NAME="mlperf-docker.$TIMESTAMP.tar"
SINGULARITY_IMAGE_NAME="mlperf.$TIMESTAMP.sif"

# Docker commit
echo "Committing the Docker container ($CONTAINER_ID) to an image..."
docker commit "$CONTAINER_ID" "mlperf-docker:$TIMESTAMP"
if [ $? -ne 0 ]; then
    echo "Error: Failed to commit Docker container."
    exit 1
fi
echo "Docker container committed successfully."

# Docker -> tar
echo "Saving the Docker image (mlperf-docker:$TIMESTAMP) as a tarball..."
docker save -o "$DOCKER_IMAGE_NAME" "mlperf-docker:$TIMESTAMP"
if [ $? -ne 0 ]; then
    echo "Error: Failed to save Docker image as tarball."
    exit 1
fi
echo "Docker image saved as tarball: $DOCKER_IMAGE_NAME."

# tar -> singularity 
echo "Building the Singularity image from the Docker tarball..."
singularity build "$SINGULARITY_IMAGE_NAME" "docker-archive://$DOCKER_IMAGE_NAME"
if [ $? -ne 0 ]; then
    echo "Error: Failed to build Singularity image."
    exit 1
fi
echo "Singularity image built successfully: $SINGULARITY_IMAGE_NAME."

# Final output
echo "$(PWD)/$DOCKER_IMAGE_NAME"
echo "Singularity image: $(PWD)/$SINGULARITY_IMAGE_NAME"
