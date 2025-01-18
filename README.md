# sind

This script sets up and runs Steam within a Docker container on Linux. Steam data is persisted in an raw disk formatted as an ext4 with case sensitivity disabled (for better compatibility with some Windows games).

The script also supports mounting saves location for persisting.

## Prerequisites

- Docker installed on your system.
- `xhost` command available for managing X11 connections.
- `chattr`, `fallocate`, `mkfs.ext4`, and `tune2fs` installed for disk and filesystem management.
- `sudo` access is needed for creating the loop device (the script will call `sudo`)

## Installation

### Convenient
```sh
git clone https://github.com/vvoland/sind && \
    cd sind && \
    sudo make install
```

### Manual
1. Build the `vlnd/steam` docker image with `docker buildx bake` (optional)
2. Copy the `sind` script to your preferred `PATH` location


## Usage

Run without arguments to simply start Steam.
```sh
sind
```

You can also pass in a game slug as an argument to launch the game directly.
```sh
sind [game]
```

### Supported games
- Civilization VI (`civ6`)

## Configurations

- Modify `DISK` and `GAMESAVES` variables to change storage locations.
- Adjust `DISK_SIZE` (`100G` by default) to allocate more or less space for Steam data (only affects the initial disk creation).
