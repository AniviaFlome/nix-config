{
  pkgs,
  ...
}:
let
  scripts = [
    # keep-sorted start case=no
    "deploy"
    "hyscript"
    "monitor-off"
    "mpv-pl"
    "nixdev"
    "npp"
    "power-profiles-switch"
    "screenshot-to-waytator"
    "soundtest"
    "winboot"
    # keep-sorted end
  ];
in
{
  imports = [
    ./secrets
  ];

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
