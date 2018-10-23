#!/usr/bin/env bash

time \
  curl \
  -X GET \
  -H "X-SCIR-AUTH: 95259886-bb8c-4002-b468-c25e210612c2" \
  -d "run_id=foo_app^^9182laksjdf982718924lkasjdf^^1" \
  -d "count=3" \
  localhost:3000/tests/next
