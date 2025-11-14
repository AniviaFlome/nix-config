{
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
    shellAliases = {
      cat = "bat";
      cd = "z";
      ls = "eza --icons -a --group-directories-first";
      man = "batman";
      rm = "rm -I";
    };
    plugins = [
      {
        name = "bass";
        src = with pkgs.fishPlugins; bass.src;
      }
      {
        name = "done";
        src = with pkgs.fishPlugins; done.src;
      }
      {
        name = "git";
        src = with pkgs.fishPlugins; plugin-git.src;
      }
      {
        name = "fzf-fish";
        src = with pkgs.fishPlugins; fzf-fish.src;
      }
    ];
  };
}
