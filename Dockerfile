FROM archlinux:latest

# Enable multilib repository for 32-bit packages (steam)
RUN echo -e '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman/pkg \
    pacman -Syu --noconfirm \
        steam \
        gamescope \
        mangohud \
        xorg-xwayland \
        mesa \
        lib32-mesa \
        vulkan-radeon \
        lib32-vulkan-radeon \
        vulkan-icd-loader \
        lib32-vulkan-icd-loader

RUN useradd -m -G video steam && mkdir -m 0755 /xdg && chown steam:steam /xdg
USER steam

CMD ["steam"]
