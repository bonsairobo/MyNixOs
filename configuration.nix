# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  pkgs,
  ...
}: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system, were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  #
  # GPUs
  #

  # Enable AMD iGPU early in the boot process
  boot.initrd.kernelModules = ["amdgpu"];
  hardware.nvidia = {
    # Drivers must be at version 525 or newer
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      # Enable PRIME offloading
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Default bus IDs exist here:
      # https://github.com/NixOS/nixos-hardware/blob/master/asus/zephyrus/ga503/default.nix
      amdgpuBusId = "PCI:7:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  # Weird that "xserver" is here when we are using Wayland. But this is required
  # to install the NVIDIA driver.
  services.xserver.videoDrivers = ["nvidia"];

  networking.hostName = "duncan-nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  #
  # System Packages
  #

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let
    # bash script to let dbus know about important env variables and
    # propagate them to relevent services run at the end of sway config
    # see
    # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
    # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
    # some user services to make sure they have the correct environment variables
    dbus-sway-environment = pkgs.writeTextFile {
      name = "dbus-sway-environment";
      destination = "/bin/dbus-sway-environment";
      executable = true;

      text = ''
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
        systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
    };
    # currently, there is some friction between sway and gtk:
    # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
    # the suggested way to set gtk settings is with gsettings
    # for gsettings to work, we need to tell it where the schemas are
    # using the XDG_DATA_DIR environment variable
    # run at the end of sway config
    configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
    };
  in
    with pkgs; [
      # Anything that is non-controversial for all users, or used by the desktop
      # environment.

      # Networking
      curl
      wget

      # Hardware tools
      acpi
      brightnessctl
      lshw
      pamixer
      pavucontrol
      pciutils

      # Desktop Env
      configure-gtk
      dbus-sway-environment
      dracula-theme
      fuzzel
      glib
      grim
      i3blocks
      mako
      slurp
      swayidle
      swaylock
      wayland
      wdisplays
      wev
      wl-clipboard
      xdg-utils

      # Apps
      firefox
    ];

  # This must be done at the system level because only root can set a user's
  # default shell.
  programs.fish.enable = true;

  programs.light.enable = true;

  # Hint electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Sway Wayland compositor
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway --unsupported-gpu
  '';

  # Sadly we can't easily install steam on a per-user basis, because installation
  # requires touching a lot of system libraries, etc.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  #
  # System Services
  #

  services.dbus.enable = true;
  services.openssh.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Laptop-specific
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 70;

      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 50;
    };
  };

  security.polkit.enable = true;
  # RealtimeKit service.
  security.rtkit.enable = true;

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  #
  # Virtualization and Containers
  #

  # Containers are particularly useful as a last resort for getting software to
  # run on NixOS. Sometimes life gives you assholes that download precompiled
  # ELF binaries onto your system.
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.duncan = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "video" "wheel"];
    shell = pkgs.fish;
  };
}
