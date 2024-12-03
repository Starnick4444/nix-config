{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home
  ];

  my-home = {
    includeFonts = true;
    isWork = true;
    useNeovim = true;
  };
}
