{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
    '';
    shellAliases = {
      ls="eza --icons -a --group-directories-first";
      cd="z";
    };
    shellInit = "
    ";
  };
}
