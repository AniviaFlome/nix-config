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
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        inherit (autopair) src;
      }
      {
        name = "bass";
        inherit (bass) src;
      }
      {
        name = "done";
        inherit (done) src;
      }
      {
        name = "fzf-fish";
        inherit (fzf-fish) src;
      }
    ];
  };
}
