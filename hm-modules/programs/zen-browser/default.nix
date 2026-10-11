{
  pkgs,
  inputs,
  username,
  ...
}:
let
  ublockFilterLists = [
    "ublock-filters"
    "ublock-badware"
    "ublock-privacy"
    "ublock-quick-fixes"
    "ublock-unbreak"
    "easylist"
    "easyprivacy"
    "urlhaus-1"
    "plowe-0"
    "adguard-spyware-url"
    "block-lan"
    "fanboy-cookiemonster"
    "ublock-cookies-easylist"
    "fanboy-ai-suggestions"
    "easylist-chat"
    "easylist-newsletters"
    "easylist-notifications"
    "easylist-annoyances"
    "adguard-mobile-app-banners"
    "adguard-other-annoyances"
    "adguard-popup-overlays"
    "adguard-widgets"
    "ublock-annoyances"
    "TUR-0"
  ];
in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    profiles.${username} = {
      bookmarks = import ./bookmarks.nix;
      extensions = import ./extensions.nix {
        inherit inputs pkgs;
        filterLists = ublockFilterLists;
      };
      settings = import ./settings.nix;
      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
      search = {
        engines = import ./search-engines.nix { inherit pkgs; };
        force = true;
        default = "ddg";
        privateDefault = "ddg";
      };
    };
  };
}
