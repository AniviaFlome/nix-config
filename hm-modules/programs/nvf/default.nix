{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ./autocmds.nix
    ./keybinds.nix
    ./lsp.nix
    ./plugins.nix
    ./settings.nix
  ];

  programs.nvf.enable = true;

  home.packages = with pkgs; [
    fd
    lsof
    tree-sitter
  ];
}
