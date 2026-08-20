FROM ghcr.io/containerpak/mesa64:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/stremio"

COPY stremio /usr/local/bin/stremio-cpak
COPY com.stremio.Stremio.desktop /usr/share/applications/com.stremio.Stremio.desktop

RUN printf '%s\n' \
      'deb http://archive.ubuntu.com/ubuntu noble main universe multiverse' \
      'deb http://security.ubuntu.com/ubuntu noble-security main universe multiverse' \
      > /etc/apt/sources.list.d/noble.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      nodejs libmpv2 qml-module-qt-labs-folderlistmodel \
      qml-module-qt-labs-platform qml-module-qt-labs-settings \
      qml-module-qtquick-controls qml-module-qtquick-dialogs \
      qml-module-qtwebchannel qml-module-qtwebengine \
      librubberband2 libuchardet0 libfdk-aac2 && \
    mkdir -p /usr/share/icons/hicolor/128x128/apps && \
    ln -s /opt/stremio/icons/smartcode-stremio_128.png /usr/share/icons/hicolor/128x128/apps/com.stremio.Stremio.png && \
    chmod 0755 /usr/local/bin/stremio-cpak && \
    cpak-clean-junk
