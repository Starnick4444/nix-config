{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };
  };
  home.packages = [ pkgs.vscode-extensions.vadimcn.vscode-lldb ];
}
