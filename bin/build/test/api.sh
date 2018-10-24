#!/usr/bin/env bash

docker build \
        $(pwd) \
        -f ./docker/api/dev/Dockerfile \
        -t stream-ci/stream-ci-runs-api-test:latest \
        --build-arg SCI_RUNS_API_USER_ID=$(id -u) \
        --build-arg SCI_RUNS_API_USER_NAME=$USER \
        --build-arg SCI_RUNS_API_GROUP_ID=$(id -g) \
        --build-arg SCI_RUNS_API_GROUP_NAME=$USER
