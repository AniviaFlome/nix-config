{
  inputs,
  ...
}:
{
  imports = [ inputs.tmenu.homeManagerModules.default ];

  programs.tmenu = {
    enable = true;
    settings = {
      display = {
        centered = true;
        width = 60;
        height = 10;
        title = "Tmenu";
        figlet = true;
        figlet_font = "standard";
        theme = "catppuccin-mocha";
      };
      menu = {
        Nix = "submenu:Nix";
      };
      "submenu.Nix" = {
        "Os Switch" = "nh os switch";
        "Home Switch" = "nh home switch";
        "Garbage Collection" = "nh clean";
        "Add Package" = "nix-pkgs add";
        "Remove Package" = "nix-pkgs remove";
      };
    };
  };
}
