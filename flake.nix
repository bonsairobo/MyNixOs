{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    # Redefine pkgs to include custom packages from the "./packages" directory.
    pkgs = import nixpkgs {
      system = system;
      config = {allowUnfree = true;};
      overlays = [
        (final: prev: {
          mdpls = final.callPackage ./packages/mdpls {};
        })
      ];
    };
  in {
    nixosConfigurations.duncan-nixos = nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.duncan = import ./home.nix;
        }
      ];
      specialArgs = inputs;
    };
  };
}
