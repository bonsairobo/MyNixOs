# Goals

This config aims to support programming and gaming while being relatively
minimal.

The development environment is focused on keyboard and shell usage, centering
around `fish`, `tmux`, and `helix`. Many modern Unix tools are provided as well.

Remaining desktop usage is also keyboard focused by using a tiling window
manager.

For gaming, Steam is installed and the `.desktop` file is modified to force
using NVIDIA PRIME offloading.

# Installation

```sh
nixos-rebuild switch --flake github:bonsairobo/MyNixOs
```

# Software

## Login

There is no graphical login. A `sway` session will be started automatically when
logging in on TTY1.

## Networking

Network Manager and `nmcli` are used for networking.

## Audio

PipeWire is used for audio, and output devices are configured with
`pavucontrol` (yes, pulseaudio apps mostly work with pipewire).

## Display

The Wayland protocol is used by the `sway` compositor + tiling window manager.

## Terminal and Shell

`wezterm` is the default terminal emulator. By default it connects to any
running `tmux` session, and `fish` is the default shell. The `starship`
prompt is used to display extra metadata about the current directory or recent
commands.

# Compatibility

There is currently minimal abstraction in these Nix modules.

- Time zone and locale are hard-coded.
- Hostname and user names are hard-coded.
- Depends on specific hardware:
  - ROG Zephyrus G15 (2021)
    - Configures the hybrid GPU drivers (AMD iGPU + NVIDIA dGPU) for PRIME offloading.
    - Sway config references ASUS device IDs (for keyboard backlight).
  - External display
    - Sway config forces a specific mode for an external 144Hz display.
- Depends on specific partitioning scheme and file systems (see `hardware-configuration.nix`)
- Sway config hardcodes path to wallpaper.
