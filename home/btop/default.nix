_: {
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      update_ms = 500;
      proc_per_core = false;
      proc_filter_kernel = true;
    };
  };
}
