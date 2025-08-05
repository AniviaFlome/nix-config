{ pkgs, system, inputs, username, ... }:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    profiles.${username} = {
      search.force = true;

      bookmarks = import ./bookmarks.nix;
      extensions = import ./extensions.nix { inherit inputs system; };
      settings = import ./settings.nix;
      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
      search = {
        engines = import ./search-engines.nix { inherit pkgs; };
        default = "ddg";
        privateDefault = "ddg";
      };
    };
  };
}
