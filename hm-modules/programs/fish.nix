{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    shellAliases =
      let
        eza = lib.getExe config.programs.eza.package;
        zoxide = lib.getExe config.programs.zoxide.package;
      in
      {
        bios = "systemctl reboot --firmware-setup";
        cat = "${lib.getExe pkgs.bat}";
        cd = "${zoxide}";
        ls = "${eza} --icons -a --group-directories-first";
        man = "${lib.getExe pkgs.bat-extras.batman}";
        rm = "rm -I";
      };
    plugins = [
      {
        name = "bass";
        inherit (pkgs.fishPlugins.bass) src;
      }
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
      {
        name = "git";
        inherit (pkgs.fishPlugins.plugin-git) src;
      }
      {
        name = "fzf-fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
    ];
  };
}
