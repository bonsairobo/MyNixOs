{
  pkgs,
  lib,
  ...
}: {
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "23.05";

  home.username = "duncan";
  home.homeDirectory = "/home/duncan";

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
  };

  home.packages = with pkgs; [
    # User-picked software.

    # CLI tools

    # Monitoring
    bottom
    procs
    sysstat

    # Networking
    dogdns
    gping
    iperf3
    nmap
    wireshark
    xh

    # Shell
    lineselect
    mcfly
    starship
    tealdeer

    # File system
    amber
    bat
    delta
    duf
    du-dust
    fd
    file
    jq
    lsd
    ripgrep
    skim
    stgit
    tmux
    tokei
    zoxide

    # Archives
    p7zip
    unzip
    xz
    zip

    # Media
    ffmpeg

    # Programming languages
    julia-bin

    # Nix
    nil
    alejandra

    # Rust
    rustup
    clang
    mold

    # Markdown
    mdpls

    # Apps
    appimage-run
    audacity
    element-desktop
    kdenlive
    keepassxc
    obs-studio
    spotify
    syncthing
    vlc
    wezterm

    # Bring it back when screen sharing works. Currently using Discord from
    # Firefox as a workaround.
    # discord
  ];

  programs = {
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          CaptivePortal = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
          FirefoxHome = {
            Search = true;
            Pocket = false;
            Snippets = false;
            TopSites = false;
            Highlights = false;
          };
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };
      };
      profiles = {
        browsing = {
          id = 0;
          isDefault = true;
        };
        discord = {
          id = 1;
        };
        work = {
          id = 2;
        };
        local_server = {
          id = 3;
        };
      };
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    helix.enable = true;
    # Currently just trying this out, not making it my default yet.
    nushell.enable = true;
  };

  # Link all configuration files (dotfiles) into home.
  # Strangely, this does not work: https://github.com/nix-community/home-manager/issues/3849
  # home.file."." = {
  #   source = ./home;
  #   recursive = true;
  # };
  # Workaround: specify each top-level entry under ./home
  home.file.".config" = {
    source = ./home/.config;
    recursive = true;
  };
  home.file.".gitconfig" = {
    source = ./home/.gitconfig;
  };
  home.file.".wezterm.lua" = {
    source = ./home/.wezterm.lua;
  };

  # Overwrite steam.desktop shortcut so that is uses PRIME
  # offloading for Steam and all its games
  home.activation.steam = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p ~/.local/share/applications
    $DRY_RUN_CMD sed 's/^Exec=/&nvidia-offload /' \
      ${pkgs.steam}/share/applications/steam.desktop \
      > ~/.local/share/applications/steam.desktop
    $DRY_RUN_CMD chmod +x ~/.local/share/applications/steam.desktop
  '';
}
