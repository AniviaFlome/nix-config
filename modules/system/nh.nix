{
  config,
  username,
  ...
}:
{
  programs.nh = {
    enable = true;
    flake = "${config.users.users.${username}.home}/nix-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  environment.etc."/nixos/flake.nix".source = "${config.users.users.${username}.home}/nix-config";
}
