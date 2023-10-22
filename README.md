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
`pavucontrol`.

## Display and Window Management

The Wayland protocol is used by the `sway` compositor + tiling window manager.

## Terminal and Shell

`wezterm` is the default terminal emulator. `fish` is the default shell. On
start, `fish` connects to any running `tmux` session. The `starship` prompt is
used to display extra metadata about the current directory or recent commands.
`nu` is also available for specific tasks.

## Development Tools

Most development occurs in the Helix editor `hx`. Very little customization is
required for Helix; by default it can use most popular language servers if they
are installed.

## Rust Development

This config is mostly tailored for writing Rust code. There are only a few ways
that this is different on NixOS:

- Only `rustup` is installed via `home-manager`. Toolchains are managed as usual.
- When building crates that have external dependencies (e.g. openssl), you must
  use `nix develop` to install those dependencies. Normally these dependencies
  are tracked with a `flake.nix` file inside of the crate directory. Rather than
  doing this with manual `nix develop` invocations, we usually use nix-direnv.
  This has the advantage of automatically augmenting the environment when you
  navigate into a crate directory. See [the instructions][nix-direnv].

[nix-direnv]: https://github.com/nix-community/nix-direnv

## Dotfile Management

All dotfiles live in `home/`. They get symlinked into `~/.config` during
install. They will be read-only at this point, so if you need to do some quick
experiments before commiting changes to this repo, there are `tryedit` and
`untryedit` functions provided by the `fish` config:

```sh
# Make foo.conf writable and creates a backup at foo.conf.bak
tryedit foo.conf

# ... make your changes ...

# Restore foo.conf from foo.conf.bak
untryedit foo.conf
```

## Gaming

For gaming, Steam is installed and the `.desktop` file is modified to force
using NVIDIA PRIME offloading.

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
