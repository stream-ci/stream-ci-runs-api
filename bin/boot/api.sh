#!/usr/bin/env bash

docker run \
        --rm \
        -it \
        --name stream-ci-runs-api-dev \
        -v $(pwd):/app \
        -p 3000:3000 \
        --network host \
        -e SCI_RUNS_API_KEY='95259886-bb8c-4002-b468-c25e210612c2' \
        stream-ci/stream-ci-runs-api-dev:latest

# Run this script to start the server.
# If you need to install/remove gems, simply stop and start the server
