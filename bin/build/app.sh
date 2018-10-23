#!/usr/bin/env bash

docker build \
        $(pwd) \
        -f ./docker/app/dev/Dockerfile \
        -t jconant/stream-ci-runs-api-app-dev:latest \
        --build-arg SCR_APP_USER_ID=$(id -u) \
        --build-arg SCR_APP_USER_NAME=$USER \
        --build-arg SCR_APP_GROUP_ID=$(id -g) \
        --build-arg SCR_APP_GROUP_NAME=$USER
