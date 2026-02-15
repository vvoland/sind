# deb
FROM scratch AS deb
ADD https://repo.steampowered.com/steam/archive/stable/steam_latest.deb /steam.deb

# base
FROM debian:trixie AS base
RUN rm -f /etc/apt/apt.conf.d/docker-clean

# gamescope-src
FROM scratch AS gamescope-src
ADD https://github.com/ValveSoftware/gamescope.git#3.16.20 /

# gamescope
FROM base AS gamescope

RUN --mount=type=cache,sharing=locked,id=gamescope-libapt,target=/var/lib/apt \
    --mount=type=cache,sharing=locked,id=gamescope-cacheapt,target=/var/cache/apt \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libluajit-5.1-dev git libevdev-dev libgav1-1 libgudev-1.0-dev libmtdev-dev libseat1 libstb0 libwacom-dev libxcb-ewmh2 libxcb-shape0-dev libxcb-xfixes0-dev libxmu-headers libyuv0 libx11-xcb-dev libxres-dev  libxmu-dev libseat-dev libinput-dev libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-res0-dev libcap-dev wayland-protocols libvulkan-dev libwayland-dev libx11-dev cmake pkg-config meson libxdamage-dev libxcomposite-dev libxcursor-dev libxxf86vm-dev libxtst-dev libxkbcommon-dev libdrm-dev libpixman-1-dev libdecor-0-dev glslang-tools libbenchmark-dev libsdl2-dev libglm-dev libeis-dev libavif-dev xwayland hwdata && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN --mount=from=gamescope-src,src=.,dst=/src,rw \
    --mount=type=cache,dst=/src/build \
    ls -lah && meson setup build/ && \
    ninja -C build/ && \
    meson install -C build --destdir /out

FROM base
# See https://repo.steampowered.com/steam/
RUN --mount=type=cache,sharing=locked,id=steam-libapt,target=/var/lib/apt \
    --mount=type=cache,sharing=locked,id=steam-cacheapt,target=/var/cache/apt \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
        libgl1-mesa-dri:i386 \
        libgl1-mesa-dri:amd64 \
        libgl1:amd64 \
        libgl1:i386 && \
    rm -rf /var/lib/apt/lists/*

# for gamescope
RUN --mount=type=cache,sharing=locked,id=steam-libapt,target=/var/lib/apt \
    --mount=type=cache,sharing=locked,id=steam-cacheapt,target=/var/cache/apt \
    apt-get update && apt-get install -y \
        libxres1 libseat1 libinput10 libavif16 libeis1 libluajit-5.1-2 mangohud xwayland && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=bind,from=deb,src=/steam.deb,dst=/steam.deb \
    --mount=type=cache,sharing=locked,id=steam-libapt,target=/var/lib/apt \
    --mount=type=cache,sharing=locked,id=steam-cacheapt,target=/var/cache/apt \
    apt-get update && apt-get install -y /steam.deb && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -G video steam && mkdir -m 0755 /xdg && chown steam:steam /xdg
USER steam

COPY --link --from=gamescope /out /

CMD ["steam"]
