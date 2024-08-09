{ pkgs, ... }: {
  home.packages = with pkgs; [
    # cargo
    # llvmPackages_18.libllvm
    # glibc
    rust-bindgen
    rust-analyzer
    gcc
  ];
}
