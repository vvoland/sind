# deb
FROM scratch AS deb
ADD https://repo.steampowered.com/steam/archive/stable/steam_latest.deb /steam.deb

# base
FROM debian:trixie AS base
RUN rm -f /etc/apt/apt.conf.d/docker-clean
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


CMD ["steam"]
