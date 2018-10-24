#!/usr/bin/env bash

docker build \
        $(pwd) \
        -f ./docker/redis/dev/Dockerfile \
        -t stream-ci/stream-ci-runs-redis-test:latest
