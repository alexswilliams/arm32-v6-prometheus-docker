#!/bin/bash

echo "Starting Prometheus $PROM_VERSION"
echo "Relevant Environment Variables (PROM_*):"
env | grep PROM_
echo ""


# Flags updated here: https://github.com/prometheus/prometheus/blob/master/cmd/prometheus/main.go
# Logger flags updated here: https://github.com/prometheus/common/blob/master/promlog/flag/flag.go
# With some defaults seen overridden for Docker here: https://github.com/prometheus/prometheus/blob/master/Dockerfile


# Booleans are treated specially in kingpin so they need passing in differently.
declare -a booleans=(
    web.enable-lifecycle
    web.enable-admin-api
    storage.tsdb.no-lockfile
    storage.tsdb.allow-overlapping-blocks
    storage.tsdb.wal-compression
)
declare -a flags=(
    config.file
    web.listen-address
    web.read-timeout
    web.max-connections
    web.external-url
    web.route-prefix
    web.user-assets
    web.console.templates
    web.console.libraries
    web.page-title
    web.cors.origin
    storage.tsdb.path
    storage.tsdb.min-block-duration
    storage.tsdb.max-block-duration
    storage.tsdb.wal-segment-size
    storage.tsdb.retention.time
    storage.tsdb.retention.size
    storage.remote.flush-deadline
    storage.remote.read-sample-limit
    storage.remote.read-concurrent-limit
    storage.remote.read-max-bytes-in-frame
    rules.alert.for-outage-tolerance
    rules.alert.for-grace-period
    rules.alert.resend-delay
    alertmanager.notification-queue-capacity
    alertmanager.timeout
    query.lookback-delta
    query.timeout
    query.max-concurrency
    query.max-samples
    log.format
    log.level
)

# Defaults taken from original prometheus Dockerfile
declare -a command=(
    "/app/prometheus"
    "--config.file=/etc/prometheus/prometheus.yml"
    "--storage.tsdb.path=/prometheus"
    "--web.console.libraries=/usr/share/prometheus/console_libraries"
    "--web.console.templates=/usr/share/prometheus/consoles"
)

for flag in "${booleans[@]}"; do
    envVarName="PROM_$(echo "${flag}" | tr 'a-z-.' 'A-Z__')"
    lowerVarValue="$(echo "${!envVarName}" | tr 'A-Z' 'a-z')"
    if [ ! -z "${lowerVarValue}" ]; then
        if [ "${lowerVarValue}" == "true" ]; then command+=("--${flag}"); else command+=("--no-${flag}"); fi
    fi
done
for flag in "${flags[@]}"; do
    envVarName="PROM_$(echo "${flag}" | tr 'a-z-.' 'A-Z__')"
    if [ ! -z "${!envVarName}" ]; then
        command+=("--${flag}=${!envVarName}")
    fi
done

unset envVarName lowerVarValue flag booleans flags
set -ex

exec "${command[@]}" $@
