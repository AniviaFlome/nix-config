{
  pkgs,
  ...
}:
{
  programs.nushell = {
    enable = true;
    loadSessionVariables = true;
    plugins = with pkgs.nushellPlugins; [
      formats
      gstat
    ];
  };
}
