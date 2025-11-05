{
  inputs,
  ...
}:
{
  imports = [ inputs.tmenu.homeManagerModules.default ];

  programs.tmenu = {
    enable = true;

    display = {
      centered = true;
      width = 60;
      height = 10;
      title = "Tmenu";
      figlet = {
        enable = true;
        font = "standard";
      };
      theme = {
        name = "catppuccin-mocha";
      };
    };
    menuItems = {
      "Nix" = "submenu:Nix";
      "System" = "submenu:System";
      "Terminal" = "alacritty";
    };
    submenu.Nix = {
      "Os Switch" = "nh os switch";
      "Home Switch" = "nh home switch";
      "Garbage Collection" = "nh clean";
      "Search Nixpkgs" = "nh search";
      "Update flake" = "nh update";
    };
  };
}
