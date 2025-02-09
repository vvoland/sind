# sind

![preview](https://github.com/user-attachments/assets/5361d92b-919c-47d3-8267-24191e4e3647)

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

## Configuration

You can override the default configuration in a config file `$HOME/.config/sind.conf`.

### Example `sind.conf`

```bash
# Size that will be allocated for the disk (only affects the initial disk creation)
DISK_SIZE=500G

# Location of the ext4 file where Steam data will be stored
DISK_PATH=$HOME/steam.ext4

# Location that will be used to store game saves
# Personally, I use a path under a samba mount so my saves are synced between multiple devices
SAVES_PATH=/samba-share/Saves
```
