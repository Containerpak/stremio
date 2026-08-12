FROM rust:1.94-slim AS build

ARG STREMIO_VERSION=1.2.0
ARG STREMIO_SHA256=aff0e1486aabccb25d4165792b3ce6dcb741bc4b50af4601f66ac3d41fb70670

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl gettext libadwaita-1-dev libgtk-4-dev \
      libmpv-dev libwebkitgtk-6.0-dev pkg-config && \
    curl --fail --location --output /tmp/stremio.tar.gz \
      "https://github.com/Stremio/stremio-linux-shell/archive/refs/tags/v${STREMIO_VERSION}.tar.gz" && \
    echo "${STREMIO_SHA256}  /tmp/stremio.tar.gz" | sha256sum --check && \
    mkdir /src && \
    tar --extract --file /tmp/stremio.tar.gz --strip-components=1 --directory /src

WORKDIR /src

RUN cargo build --release && \
    install -Dm755 target/release/stremio-linux-shell /out/usr/bin/stremio && \
    install -Dm644 data/com.stremio.Stremio.desktop /out/usr/share/applications/com.stremio.Stremio.desktop && \
    install -Dm644 data/com.stremio.Stremio.gschema.xml /out/usr/share/glib-2.0/schemas/com.stremio.Stremio.gschema.xml && \
    install -Dm644 data/icons/hicolor/scalable/apps/com.stremio.Stremio.svg /out/usr/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

FROM ghcr.io/containerpak/gtk:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/stremio"

COPY --from=build /out/ /

RUN apt-get update && \
    apt-get install -y --no-install-recommends libmpv2 libwebkitgtk-6.0-4 && \
    glib-compile-schemas /usr/share/glib-2.0/schemas && \
    cpak-clean-junk
