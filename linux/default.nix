{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.my-linux;
in {
  imports = [
    ./wm
    ./nix-path
    ./games # TODO make this optional work (maybe always import the module and have the option defined there)
    ./style
  ];

  options.my-linux = {
    enableNixOptimise = lib.mkEnableOption "nix auto optimizations";
    includeGames = lib.mkEnableOption "games";
  };

  config = {
    nix = {
      # package = pkgs.nixStable;
      settings = {
        auto-optimise-store = cfg.enableNixOptimise;
        # Add cache for nix-community, used mainly for neovim nightly
        substituters = ["https://nix-community.cachix.org" "https://cosmic.cachix.org/" "https://chaotic-nyx.cachix.org/"];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        ];
      };
      gc = optionalAttrs cfg.enableNixOptimise {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # custom options defined in nix-path
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;

      # Enable Flakes
      extraOptions = ''
        experimental-features = nix-command flakes
        ${optionalString cfg.enableNixOptimise ''
          min-free = ${toString (100 * 1024 * 1024)}
          max-free = ${toString (1024 * 1024 * 1024)}
        ''}
      '';
    };

    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;
    programs.wireshark.enable = true;
    programs.nix-index-database.comma.enable = true;

    virtualisation.docker.enable = true;
    # programs.nix-ld.enable = true;

    system.stateVersion = "24.05";
  };
}
