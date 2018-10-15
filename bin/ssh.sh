#!/usr/bin/env bash

docker exec -it -u $(id -u):$(id -g) stream-ci-runner-app-dev /bin/bash
