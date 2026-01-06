{
  pkgs,
  ...
}:
let
  scripts = [
    "hyscript"
    "monitor-off"
    "npp"
    "power-profiles-switch"
    "soundtest"
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
      gum
      libnotify
      lm_sensors
      nix-search-tv
      sysstat
    ];
}
