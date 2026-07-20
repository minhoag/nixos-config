{
  description = "My NixOS niri flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak?ref=latest";
    };

    sfdx-nix.url = "github:rfaulhaber/sfdx-nix";

    fcitx5-lotus = {
      url = "github:LotusInputMethod/fcitx5-lotus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    cursor = {
      url = "github:omarcresp/cursor-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    samaritan-sddm-theme = {
      url = "github:omerwk/samaritan-sddm-theme";
      flake = false;
    };

    phonto = {
      url = "github:museslabs/phonto";
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

      nixosConfigurations = {
        nixos = mkHost "nixos";
      };
    };
}
