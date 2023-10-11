# Goals

This config aims to support programming and gaming while being minimal,
responsive, and efficient with laptop battery. The keyboard is emphasized as the
primary input method for programming and desktop navigation, although the mouse
and touchpad are still usable when GUIs like browsers make them necessary.

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

## Display and Window Management

The Wayland protocol is used by the `sway` compositor + tiling window manager.

## Terminal and Shell

`wezterm` is the default terminal emulator. By default it connects to any
running `tmux` session, and `fish` is the default shell. The `starship`
prompt is used to display extra metadata about the current directory or recent
commands.

## Development Tools

The development environment is focused on keyboard and shell usage, centering
around `fish`, `tmux`, and `helix`. Many modern Unix tools are provided as well.

## Dotfile Management

All dotfiles live in `home/`. They get symlinked into `~/.config` during
install. They will be read-only at this point, so if you need to do some
quick experiments, it is easiest to do:

```sh
mv $some_file "$some_file.bak"
cp "$some_file.bak" $some_file
chmod +w $some_file
# ... make your changes
```

before finalizing the changes in this repo.

## Gaming

For gaming, Steam is installed and the `.desktop` file is modified to force
using NVIDIA PRIME offloading.

## Rust Development

This config is mostly catered to writing Rust code. There are only a few ways
that this is different on NixOS:

- Only rustup is installed via `home-manager`. Toolchains are managed as usual.
- When building crates that have external dependencies (e.g. openssl), you must
  use `nix-shell` to install those dependencies and make them visible to `pkg-
  config`. Normally these dependencies are tracked with a `shell.nix` file
  inside of the crate directory. Rather than doing this with raw `nix- shell`
  invocations, we use nix-direnv. This has the advantage of automatically
  augmenting the environment when you navigate into a crate directory. See [the
  instructions](https://github.com/nix-community/nix-direnv).

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
