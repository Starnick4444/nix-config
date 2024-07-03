{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    qemu
  ];

  home.file.".config/libvirt/qemu.conf".text = ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';
}
