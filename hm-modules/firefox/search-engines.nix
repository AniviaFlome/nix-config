{ pkgs, username, ... }:

{
  programs.firefox = {
    profiles.${username} = {
      search.engines = {
"Nix Search" = {
  urls = [{
    template = "https://search.nixos.org/packages";
    params = [
      { name = "type"; value = "packages"; }
      { name = "query"; value = "{searchTerms}"; }
    ];
  }];
  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
definedAliases = [ "@ns" ];
};
      };
    };
  };
}
