{
  programs.fish = {
    enable = true;
    catppuccin.enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
    '';
    shellAliases = {
      ls="eza --icons -a --group-directories-first";
      cd="z";
    };
    shellInit = "
      starship init fish | source
      zoxide init fish | source
    ";
  };
}
