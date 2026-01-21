{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
      };
      keys.normal = {
        space.w = ":w";
      };
    };
    extraPackages = with pkgs; [
      marksman
      nil
      rust-analyzer
      typescript-language-server
    ];
  };
}
