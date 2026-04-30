{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        auto-format = true;
        line-number = "relative";
      };
      keys.normal = {
        space.w = ":w";
      };
    };
    extraPackages = with pkgs; [
      marksman
      nil
      unstable.rust-analyzer
      typescript-language-server
    ];
  };
}
