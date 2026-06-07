{ inputs, ... }:
{
  flake.modules.homeManager.nix-index = {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];

    programs.nix-index = {
      enable = true;
    };
  };
}
