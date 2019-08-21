#!/usr/bin/env bash

set -ex

function buildAndPush {
    local version=$1
    local imagename="alexswilliams/arm32v6-prometheus"
    local fromline=$(grep -e '^FROM ' Dockerfile | tail -n -1 | sed 's/^FROM[ \t]*//' | sed 's#.*/##' | sed 's/:/-/' | sed 's/#.*//' | sed -E 's/ +.*//')

    docker build -t ${imagename}:${version} \
        --build-arg VERSION=${version} \
        --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
        --build-arg VCS_REF=$(git rev-parse --short HEAD) \
        --file Dockerfile . \
    && docker tag ${imagename}:${version} ${imagename}:${version}-${fromline} \
    && docker push ${imagename}:${version} \
    && docker push ${imagename}:${version}-${fromline} \
    && (
        if [ "$2" == "latest" ]; then
            docker tag ${imagename}:${version} ${imagename}:latest \
            && docker push ${imagename}:latest
        fi
    )
}

#buildAndPush "2.7.0"
#buildAndPush "2.7.1"
#buildAndPush "2.7.2"
#buildAndPush "2.8.0"
#buildAndPush "2.8.1"
#buildAndPush "2.9.0"
#buildAndPush "2.9.1"
#buildAndPush "2.9.2"
#buildAndPush "2.10.0"
#buildAndPush "2.11.0"
#buildAndPush "2.11.1"
buildAndPush "2.11.2"
buildAndPush "2.12.0" latest

curl -X POST "https://hooks.microbadger.com/images/alexswilliams/arm32v6-prometheus/H8lh7yTJah4vJT69Kjz-00QLM44="
