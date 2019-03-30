#!/usr/bin/env bash

set -ex

function buildAndPush {
    local version=$1

    docker build -t alexswilliams/arm32v6-prometheus:${version} --build-arg VERSION=${version} --file Dockerfile.arm32v6 . \
    && docker push alexswilliams/arm32v6-prometheus:${version}
}

# buildAndPush "2.6.1"
# buildAndPush "2.7.0"
# buildAndPush "2.7.1"
# buildAndPush "2.7.2"
# buildAndPush "2.8.0"
buildAndPush "2.8.1"
