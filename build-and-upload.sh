#!/usr/bin/env bash

set +ex

function buildAndPush {
    local version=$1
    docker build -t alexswilliams/:${version} --build-arg VERSION=${version} --file Dockerfile.arm32v6 .
    docker push
}

docker login --username=alexswilliams

buildAndPush "2.6.1"

