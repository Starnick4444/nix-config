{pkgs, ...}: let
  myAliases = {
    ls = "eza -l";
    cat = "bat";
    fd = "fd -Lu";
    # Unclear if this works
    nixos-rebuild = "systemd-run --no-ask-password --uid=0 --system --scope -p MemoryLimit=16000M -p CPUQuota=80% nixos-rebuild";
  };
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    bat
    eza
    fd
  ];
}
