FROM arm32v6/alpine:3.11.5
# Updated here: https://hub.docker.com/r/arm32v6/alpine/tags
# Inspired from: https://github.com/prometheus/prometheus/blob/master/Dockerfile

ARG VERSION
ENV PROM_VERSION=${VERSION}

RUN apk add bash coreutils \
    && mkdir -p /app/data \
    && mkdir -p /etc/prometheus \
    && mkdir -p /usr/share/prometheus \
    && cd /app \
    && wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-armv6.tar.gz \
    && tar xzf prometheus-${VERSION}.linux-armv6.tar.gz \
    && rm -f prometheus-${VERSION}.linux-armv6.tar.gz \
    && mv /app/prometheus-${VERSION}.linux-armv6/* /app/ \
    && rmdir /app/prometheus-${VERSION}.linux-armv6 \
    && ln -s /app/prometheus.yml /etc/prometheus/prometheus.yml \
    && ln -s /app/data /etc/prometheus/data \
    && ln -s /app/data /prometheus \
    && ln -s /app/consoles /etc/prometheus/consoles \
    && ln -s /app/consoles /usr/share/prometheus/consoles \
    && ln -s /app/console_libraries /etc/prometheus/console_libraries \
    && ln -s /app/console_libraries /usr/share/prometheus/console_libraries \
    && chown -R nobody:nogroup /etc/prometheus /app

USER nobody
VOLUME [ "/app/data" ]
WORKDIR /etc/prometheus
EXPOSE 9090
COPY run.sh /run.sh
ENTRYPOINT [ "/run.sh" ]


ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Prometheus (arm32v6)" \
      org.label-schema.description="Prometheus - Repackaged for ARM32v6" \
      org.label-schema.url="https://prometheus.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/alexswilliams/arm32-v6-prometheus-docker" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
