{ pkgs, inputs, username, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.${username} = {
      search.force = true;

      bookmarks = import ./bookmarks.nix;
      search.engines = import ./search-engines.nix;
      settings = import ./settings.nix;
    };
  };
}
