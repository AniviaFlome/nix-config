{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-themes.homeModules.default ];

  themes = {
    enable = true;
    theme = "catppuccin";
    variant = "mocha";
    accent = "mauve";

    kvantum.enable = false;
  };
}
