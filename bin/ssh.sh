#!/usr/bin/env bash

docker exec -it -u $(id -u):$(id -g) stream-ci-runs-api-app-dev /bin/bash
