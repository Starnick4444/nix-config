{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    nixos-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    # home-manager-unstable = {
    #   url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    # hyprland = {
    #   url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # url = "git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=c5feee1e357f3c3c59ebe406630601c627807963&submodules=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nyaa.url = "github:Beastwick18/nyaa";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-master
    , home-manager
    , nixos-stable
    , flake-parts
    , ...
    }:
    with nixpkgs.lib;
    let
      # overlay-master = final: prev: {
      #   master = nixpkgs-master.legacyPackages.${prev.system};
      # };
      # todo remove above
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
        };
        overlays = [
          # "pkgs" currently points to unstable
          # The following overlay allows you to specify "pkgs.stable" for stable versions
          # and "pkgs.master" for versions on master
          (
            final: prev:
              let
                inherit (prev.stdenv) system;
              in
              {
                master = nixpkgs-master.legacyPackages.${system};
                stable = nixos-stable.legacyPackages.${system};
              }
          )
          # Add in custom defined packages in the pkgs directory
          # (
          #   final: prev: { flake = self; } // import ./pkgs final prev
          # )
        ];
      };
      # sharedOptions = { config, options, ... }: {
      #  options.myWindowManager = mkOption {
      #     type = types.enum [ "hyprland" "cosmic" ];
      #     default = "hyprland";
      #     description = "Choose which Window Manager to use (hyprland or cosmic)";  
      #   };

      #   options = {
      #     # This is where the configuration is applied
      #     windowManager = config.myWindowManager;
      #   };
      # };
      nixosModules = { user, host }: with inputs; [
        # WM config
        # sharedOptions
        # Main `nixos` config
        (./. + "/hosts/${host}/configuration.nix")
        # `home-manager` module
        home-manager.nixosModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          # Pins channels and flake registry to use the same nixpkgs as this flake.
          nix.registry = nixpkgs.lib.mapAttrs (_: value: { flake = value; }) inputs;
          # `home-manager` config
          users.users.${user} = {
            home = "/home/${user}";
            isNormalUser = true;
            group = "${user}";
            extraGroups = [ "wheel" ];
          };
          users.groups.${user} = { };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user} = import (./. + "/hosts/${host}/home.nix");
            extraSpecialArgs = { windowManager = "hyprland"; };
            sharedModules = [
              # sharedOptions
              # nix-index-database.hmModules.nix-index
            ];
          };
        }
      ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        nixosConfigurations = {
          mainpc = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = nixosModules {
              user = "starnick";
              host = "mainpc";
            };
            specialArgs = { inherit inputs nixpkgs; windowManager = "hyprland"; };
          };
          laptop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = nixosModules {
              user = "starnick";
              host = "laptop";
            };
            specialArgs = { inherit inputs nixpkgs; windowManager = "hyprland"; };
          };
        };
      };
      systems = [ "x86_64-linux" ];
    };
}
