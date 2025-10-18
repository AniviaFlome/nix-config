{ pkgs, ... }:

{
  "Nix Packages" = {
    urls = [
      {
        template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@nix" ];
  };
  "NixOS Wiki Unofficial" = {
    urls = [
      {
        template = "https://nixos.wiki/index.php?search={searchTerms}&go=Go}";
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@nw" ];
  };
  "NixOS Wiki" = {
    urls = [
      {
        template = "https://wiki.nixos.org/w/index.php?search={searchTerms}&title=Special%3ASearch&wprov=acrw1_-1";
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@nww" ];
  };
  "Arch Wiki" = {
    urls = [
      {
        template = "https://wiki.archlinux.org/index.php?search={searchTerms}&title=Special%3ASearch";
      }
    ];
    definedAliases = [ "@aw" ];
  };
  "Leta - Google" = {
    urls = [
      {
        template = "https://leta.mullvad.net/search?q={searchTerms}&engine=google";
      }
    ];
    definedAliases = [ "@lt" ];
  };
}
