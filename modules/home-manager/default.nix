# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  git = import ./git/git.nix;
  sh = import ./shell/sh.nix;
  cli-collection = import ./shell/cli-collection.nix;
  firefox = import ./browser/firefox.nix;
  virtualization = import ./virtualization/virtualization.nix;
  alacritty = import ./terminal/alacritty.nix;
  rust = import ./lang/rust/rust.nix;
}
