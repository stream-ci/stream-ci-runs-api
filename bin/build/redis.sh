#!/usr/bin/env bash

docker build \
        $(pwd) \
        -f ./docker/redis/dev/Dockerfile \
        -t jconant/stream-ci-runner-redis-dev:latest