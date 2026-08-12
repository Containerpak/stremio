FROM ubuntu:26.04 AS source

ARG STREMIO_SHA256=1028f1a38a70fc66bfcda1c8a9e1674231e17ac81774fc48859ed8f53c7a6039

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    curl --fail --location --output /tmp/stremio.deb \
      https://dl.strem.io/shell-linux/v4.4.168/stremio_4.4.168-1_amd64.deb && \
    echo "${STREMIO_SHA256}  /tmp/stremio.deb" | sha256sum --check

FROM ghcr.io/containerpak/mesa:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/stremio"

COPY --from=source /tmp/stremio.deb /tmp/stremio.deb
COPY stremio /usr/bin/stremio
COPY com.stremio.Stremio.desktop /usr/share/applications/com.stremio.Stremio.desktop

RUN apt-get update && \
    apt-get install -y --no-install-recommends /tmp/stremio.deb && \
    install -Dm644 /opt/stremio/icons/smartcode-stremio_128.png /usr/share/icons/hicolor/128x128/apps/com.stremio.Stremio.png && \
    chmod 0755 /usr/bin/stremio && \
    rm /tmp/stremio.deb && \
    cpak-clean-junk
