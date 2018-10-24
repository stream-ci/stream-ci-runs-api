#!/usr/bin/env bash

docker run \
        --rm \
        -it \
        --name stream-ci-runs-api-test \
        -v $(pwd):/app \
        -p 3000:3000 \
        --network host \
        -e SCI_RUNS_API_KEY='SOME-TEST-KEY' \
        stream-ci/stream-ci-runs-api-test:latest

# Run this script to start the server.
# If you need to install/remove gems, simply stop and start the server
