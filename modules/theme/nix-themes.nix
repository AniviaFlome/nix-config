{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-themes.nixosModules.default ];

  themes = {
    enable = true;
    theme = "catppuccin";
    variant = "mocha";
    accent = "mauve";
  };
}
