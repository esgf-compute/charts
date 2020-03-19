#! /bin/bash

DOCKERFILE=${1}
shift

buildctl-daemonless.sh \
  build \
  --frontend dockerfile.v0 \
  --local context=. \
  --local dockerfile=${DOCKERFILE} \
  $@
