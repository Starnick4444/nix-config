{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
    settings = {
      vim_keys = true;
      update_ms = 500;
      proc_per_core = false;
      proc_filter_kernel = true;
    };
  };
}
