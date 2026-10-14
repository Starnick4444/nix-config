{ pkgs, ... }:
{
  imports = [ ./jujutsu.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      # Development
      tokei
      # Device imaging
      # rpi-imager
      #etcher #was disabled in nixpkgs due to dependency on insecure version of Electron
      # Productivity
      drawio
      libreoffice
      # Privacy
      #veracrypt
      #keepassxc
      # Media production
      # blender-hip # -hip variant includes h/w accelrated rendering with AMD RNDA gpus
      # gimp
      # inkscape
      # VM and RDP
      # remmina
      fastfetch
      onefetch
      fluent-reader
      ;
  };
}
