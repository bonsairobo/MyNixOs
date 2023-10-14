{
  pkgs,
  lib,
  ...
}: {
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "18.09";

  home.username = "duncan";
  home.homeDirectory = "/home/duncan";

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
    bat
    delta
    duf
    du-dust
    fd
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

    # Programming languages
    julia-bin

    # Nix
    nil
    alejandra

    # Rust
    rustup
    clang
    mold

    # Apps
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
