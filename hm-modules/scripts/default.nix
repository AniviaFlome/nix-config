{
  pkgs,
  ...
}:
let
  scripts = [
    "hyscript"
    "monitor-off"
    "mpv-pl"
    "npp"
    "power-profiles-switch"
    "soundtest"
    "stats"
    "winboot"
    # Secrets management scripts
    "create-system-key"
    "deploy-pub-key"
    "ensure-system-key-exists"
    "extract-pub-key"
    "generate-ssh-key"
    "list-secrets"
    "print-secret"
    "remove-secret"
    "secrets-menu"
    "set-hashed-password"
    "set-secret"
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
      whisper-cpp
      age
      jq
      mkpasswd
      openssh
      sops
      wl-clipboard
      xdg-utils
      yq-go
    ];
}
