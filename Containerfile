FROM ghcr.io/containerpak/webkitgtk6:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/stremio"

COPY stremio /usr/local/bin/stremio-cpak
COPY com.stremio.Stremio.desktop /usr/share/applications/com.stremio.Stremio.desktop

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      nodejs libmpv2 && \
    chmod 0755 /usr/local/bin/stremio-cpak && \
    cpak-clean-junk
