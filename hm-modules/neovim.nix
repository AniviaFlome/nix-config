{ nixvim, ... }:

{
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    plugins = {
      lsp = {
        enable = true;
        servers.nixd.enable = true;
      };
    };
  };
}
