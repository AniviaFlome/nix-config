{ pkgs, ... }:
let
  scripts = [
    "create-system-key"
    "deploy-pub-key"
    "ensure-system-key-exists"
    "extract-pub-key"
    "generate-ssh-key"
    "init-secrets"
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
    (scripts |> map (script: ./${script}.sh |> builtins.readFile |> writeScriptBin script))
    ++ [
      age
      gum
      jq
      mkpasswd
      openssh
      sops
      wl-clipboard
      xdg-utils
      yq-go
    ];
}
