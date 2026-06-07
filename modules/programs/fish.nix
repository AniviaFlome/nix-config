{
  flake.modules.homeManager.fish =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set -U fish_greeting
           ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        '';
        plugins = with pkgs.fishPlugins; [
          {
            name = "autopair";
            src = autopair;
          }
          {
            name = "bass";
            src = bass;
          }
          {
            name = "done";
            src = done;
          }
          {
            name = "fzf-fish";
            src = fzf-fish;
          }
        ];
      };
    };
}
