FROM arm32v6/alpine:3.11.2

ARG VERSION
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

RUN mkdir -p /app && mkdir -p /etc/prometheus
WORKDIR /etc/prometheus

RUN cd /app \
    && wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-armv6.tar.gz \
    && tar xzf prometheus-${VERSION}.linux-armv6.tar.gz \
    && rm -f prometheus-${VERSION}.linux-armv6.tar.gz \
    && mv /app/prometheus-${VERSION}.linux-armv6/* /app/ \
    && rmdir /app/prometheus-${VERSION}.linux-armv6 \
    && mkdir -p /app/data \
    && ln -s /app/prometheus.yml /etc/prometheus/prometheus.yml \
    && ln -s /app/data /etc/prometheus/data \
    && ln -s /app/consoles /etc/prometheus/consoles \
    && ln -s /app/console_libraries /etc/prometheus/console_libraries

COPY run.sh /run.sh
ENV PROM_VERSION=${VERSION}

EXPOSE 9090
ENTRYPOINT [ "/run.sh" ]
