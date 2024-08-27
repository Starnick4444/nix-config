{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # hyprland = {
    #   url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # url = "git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=c5feee1e357f3c3c59ebe406630601c627807963&submodules=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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
   # , hyprland
    , rust-overlay
    , nixpkgs-master
    , ...
    } @ inputs:
    let
      overlay-master = final: prev: {
        master = nixpkgs-master.legacyPackages.${prev.system};
      };
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          inputs.home-manager.nixosModules.default
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default overlay-master ];
            environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
          })
          ./modules/nixos/nix-path/module.nix
        ];
      };
    };
}
