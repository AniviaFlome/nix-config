{ pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.aniviaflome = {
      search.force = true;

      bookmarks = import ./bookmarks.nix;
      #extensions = import ./extensions.nix;
      search.engines = import ./search-engines.nix;
      settings = import ./settings.nix;
    };
  };
}
