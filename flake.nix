{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    rust-overlay.url = "github:oxalica/rust-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nyaa.url = "github:Beastwick18/nyaa";
  };

  outputs =
    { self
    , nixpkgs
    , hyprland
    , rust-overlay
    , nixpkgs-small
    , ...
  } @ inputs: 
  let
    overlay-small = final: prev: {
        small = nixpkgs-small.legacyPackages.${prev.system};
      };
  in{
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          inputs.home-manager.nixosModules.default
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default overlay-small ];
            environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
          })
          ./modules/nixos/nix-path/module.nix
        ];
      };
    };
}
