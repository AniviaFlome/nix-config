{ pkgs, inputs, username, system, ... }:

let
  zen-browser = pkgs.lib.makeOverridable (_: inputs.zen-browser.packages."${system}".default);
in

{
  imports = [
    ./bookmarks.nix
    ./search-engines.nix
    ./settings.nix
  ];

  programs.firefox = {
    enable = true;
    package = zen-browser {};
    profiles.${username} = {
      search.force = true;
    };
  };
}
