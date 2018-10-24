#!/usr/bin/env bash

docker run \
        --rm \
        -it \
        --name stream-ci-runs-redis-dev \
        -p 6379:6379 \
        stream-ci/stream-ci-runs-redis-dev:latest

# Run this script to start the redis server.
