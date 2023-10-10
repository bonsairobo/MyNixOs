{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { nixpkgs, ... }: {
    nixosConfigurations.duncan-nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
      ];
      specialArgs = inputs;
    };
  };
}
