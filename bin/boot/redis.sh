#!/usr/bin/env bash

docker run \
        --rm \
        -it \
        --name stream-ci-runner-redis-dev \
        -p 6379:6379 \
        jconant/stream-ci-runner-redis-dev:latest

# Run this script to start the redis server.
