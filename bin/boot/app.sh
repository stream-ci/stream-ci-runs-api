#!/usr/bin/env bash

docker run \
        --rm \
        -it \
        --name stream-ci-runner-app-dev \
        -v $(pwd):/app \
        -p 3000:3000 \
        jconant/stream-ci-runner-app-dev:latest

# Run this script to start the server.
# If you need to install/remove gems, simply stop and start the server
