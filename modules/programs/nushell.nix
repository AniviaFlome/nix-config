{
  flake.modules.homeManager.nushell =
    { pkgs, ... }:
    {
      programs.nushell = {
        enable = true;
        plugins = with pkgs.nushellPlugins; [
          formats
          gstat
        ];
      };
    };
}
