{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.shellAliases = {
    bios = "systemctl reboot --firmware-setup";
    cat = lib.getExe config.programs.bat.package;
    cp = "cp --recursive --verbose --progress";
    ls = "${lib.getExe config.programs.eza.package} --icons -a --group-directories-first";
    man = lib.getExe pkgs.bat-extras.batman;
    rm = "rm -I";
    tree = "${lib.getExe config.programs.eza.package} --tree --git-ignore --group-directories-first";
  };
}
