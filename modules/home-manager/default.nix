{
  imports = [
    ./git/git.nix
    ./shell/sh.nix
    ./shell/cli-collection.nix
    ./shell/btop.nix
    ./shell/starship.nix
    ./browser/firefox.nix
    ./virtualization/virtualization.nix
    ./terminal/kitty.nix
    # ./terminal/alacritty.nix
    ./lang/rust/rust.nix
    ./direnv/direnv.nix
    ./wm/hyprland.nix
    ./wm/hyprlock.nix
    ./wm/waybar/waybar.nix
    ./wm/rofi/rofi.nix
    ./gtk/gtk.nix
    ./editor/nvim.nix
    # ./surrealdb/default.nix
  ];
}
