{
  inputs,
  ...
}:
{
  imports = [ inputs.tmenu.homeManagerModules.default ];

  programs.tmenu = {
    enable = true;
    extraConfig = ''
      [display]
      centered = true
      figlet = true
      figlet_font = "standard"
      height = 10
      theme = "catppuccin-mocha"
      title = "Tmenu"
      width = 60

      [menu]
      Nix = "submenu:Nix"

      ["submenu.Nix"]
      "Os Switch" = "nh os switch"
      "Add Package" = "nix-pkgs add"
      "Garbage Collection" = "nh clean"
      "Home Switch" = "nh home switch"
      "Remove Package" = "nix-pkgs remove"
    '';
  };
}
