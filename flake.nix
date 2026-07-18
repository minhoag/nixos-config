{
  description = "My NixOS niri flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak?ref=latest";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      installerPkg = import ./installer.nix { inherit self pkgs; }; # this is so that we can use installer.nix as a module
      mkHost =
        host:
        let
          # 1. Import your list of overlays for this specific host
          hostOverlays = import ./overlays { inherit self inputs host; };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            inputs.disko.nixosModules.disko
            ./hosts/${host}/configuration.nix
            {
              nixpkgs.overlays = [
                hostOverlays.additions
                hostOverlays.modifications
                inputs.niri.overlays.niri
              ];
            }
          ];
          specialArgs = {
            inherit
              self
              inputs
              outputs
              host
              ;
          };
        };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      # 2. Expose the installer binary layout package matching flake targets
      packages.${system}.installer = installerPkg;

      # 3. Expose the interactive executable target application block
      apps.${system}.installer = {
        type = "app";
        program = "${installerPkg}/bin/installer";
      };

      nixosConfigurations = {
        nixos = mkHost "nixos";
      };
    };
}
