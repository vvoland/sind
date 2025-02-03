FROM scratch AS deb
ADD https://repo.steampowered.com/steam/archive/stable/steam_latest.deb /steam.deb

FROM ubuntu:noble
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
		mangohud && \
	rm -rf /var/lib/apt/lists/*

RUN --mount=type=bind,from=deb,src=/steam.deb,dst=/steam.deb \
    --mount=type=cache,sharing=locked,id=steam-libapt,target=/var/lib/apt \
    --mount=type=cache,sharing=locked,id=steam-cacheapt,target=/var/cache/apt \
	apt-get update && apt-get install -y /steam.deb && \
	rm -rf /var/lib/apt/lists/*

COPY --link ./init.sh /init.sh

RUN usermod ubuntu -a -G video
USER ubuntu

CMD ["steam"]
