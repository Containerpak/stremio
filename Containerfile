FROM ubuntu:26.04 AS source

ARG STREMIO_VERSION=4.4.168
ARG STREMIO_SHA256=1028f1a38a70fc66bfcda1c8a9e1674231e17ac81774fc48859ed8f53c7a6039

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl dpkg && \
    curl --fail --location --output /tmp/stremio.deb \
      "https://dl.strem.io/shell-linux/v${STREMIO_VERSION}/stremio_${STREMIO_VERSION}-1_amd64.deb" && \
    echo "${STREMIO_SHA256}  /tmp/stremio.deb" | sha256sum --check && \
    dpkg-deb --extract /tmp/stremio.deb /out

FROM ghcr.io/containerpak/mesa:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/stremio"

COPY --from=source /out/ /
COPY stremio /usr/bin/stremio
COPY com.stremio.Stremio.desktop /usr/share/applications/com.stremio.Stremio.desktop

RUN printf '%s\n' \
      'deb http://archive.ubuntu.com/ubuntu noble main universe multiverse' \
      'deb http://security.ubuntu.com/ubuntu noble-security main universe multiverse' \
      > /etc/apt/sources.list.d/noble.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      nodejs libmpv1 qml-module-qt-labs-folderlistmodel \
      qml-module-qt-labs-platform qml-module-qt-labs-settings \
      qml-module-qtquick-controls qml-module-qtquick-dialogs \
      qml-module-qtwebchannel qml-module-qtwebengine \
      librubberband2 libuchardet0 libfdk-aac2 && \
    install -Dm644 /opt/stremio/icons/smartcode-stremio_128.png /usr/share/icons/hicolor/128x128/apps/com.stremio.Stremio.png && \
    chmod 0755 /usr/bin/stremio && \
    cpak-clean-junk
