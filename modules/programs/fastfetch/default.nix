{
  flake.modules.homeManager.fastfetch =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ fastfetch ];
      xdg.configFile."fastfetch" = {
        source = ./fastfetch;
        recursive = true;
      };
    };
}
