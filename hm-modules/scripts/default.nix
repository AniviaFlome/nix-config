{
  pkgs,
  ...
}:
let
  scripts = [
    "deploy"
    "hyscript"
    "monitor-off"
    "mpv-pl"
    "npp"
    "power-profiles-switch"
    "soundtest"
    "nixdev"
    "winboot"
  ];
in
{
  imports = [ ./secrets ];

  home.packages =
    with pkgs;
    (scripts |> map (script: ./${script}.sh |> builtins.readFile |> writeScriptBin script))
    ++ [
      age
      alsa-utils
      bat
      dash
      efibootmgr
      fzf
      gawk
      gum
      jq
      libnotify
      lm_sensors
      mkpasswd
      nix-search-tv
      shellcheck
      sysstat
      sops
      openssh
      wl-clipboard
      xdg-utils
      yq-go
    ];
}
