#!/usr/bin/env bash

time \
  curl \
  -X POST \
  -H "Content-Type: application/json" \
  -H "X-SCIR-AUTH: 95259886-bb8c-4002-b468-c25e210612c2" \
  --data "{\"tests\":{\"paths\":[\"some/file/path/foo.rb\",\"some/file/path/bar.rb\"],\"run_id\":\"foo_app^^9182laksjdf982718924lkasjdf^^1\"}}" \
  localhost:3000/tests/new
