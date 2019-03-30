#!/bin/sh




/app/prometheus \
    --config.file=${PROM_CONFIG_FILE:-/etc/prometheus/prometheus.yml} \
    --log.format=${PROM_LOG_FORMAT:-logfmt} \
    --log.level=${PROM_LOG_LEVEL:-info} \
    --web.console.templates=${PROM_WEB_CONSOLE_TEMPLATES:-/etc/prometheus/consoles} \
    --web.console.libraries=${PROM_WEB_CONSOLE_LIBRARIES:-/etc/prometheus/console-libraries} \
    --query.max-concurrency=${PROM_QUERY_MAX_CONCURRENCY:-20} \
    --query.max-samples=${PROM_QUERY_MAX_SAMPLES:-50000000} \
    --query.timeout=${PROM_QUERY_TIMEOUT:-2m} \
    --storage.tsdb.path=${PROM_STORAGE_TSDB_PATH:-/etc/prometheus/data/} \
    --storage.tsdb.retention.time=${PROM_STORAGE_TSDB_RETENTION_TIME:-0s} \
    --storage.tsdb.retention.size=${PROM_STORAGE_TSDB_RETENTION_SIZE:-0B} \
    --web.route-prefix=${PROM_WEB_ROUTE_PREFIX:-/} \
    $@


