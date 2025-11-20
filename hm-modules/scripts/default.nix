{
  pkgs,
  ...
}:
let
  scripts = [
    "hyscript"
    "nix-pkgs"
    "power-profiles-switch"
    "stats"
    "winboot"
  ];
in
{
  home.packages =
    with pkgs;
    (map (script: writeShellScriptBin script (builtins.readFile ./${script}.sh)) scripts)
    ++ [
      alsa-utils
      bat
      efibootmgr
      fzf
      gawk
      libnotify
      lm_sensors
      nix-search-tv
      sysstat
    ];
}
