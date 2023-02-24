#!/bin/bash
IMAGE_PATH=$1
IMAGE_NAME=$(echo $IMAGE_PATH|awk -F: '{print $(NF-1)}'|awk -F/ '{print $NF}')
IMAGE_VERSION=$(echo $IMAGE_PATH|awk -F: '{print $(NF)}')
echo "$IMAGE_NAME is $IMAGE_VERSION"
echo "FROM $IMAGE_PATH" > Dockerfile
/usr/local/mylab_cli/mylabbuild tsaicch/gitlabee-image/${IMAGE_NAME}:${IMAGE_VERSION}
