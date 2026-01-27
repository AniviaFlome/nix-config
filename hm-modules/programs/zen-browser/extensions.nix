{
  pkgs,
  ...
}:
{
  packages = with pkgs.firefox-addons; [
    augmented-steam
    bitwarden
    buster-captcha-solver
    clearurls
    darkreader
    jump-cutter
    languagetool
    protondb-for-steam
    return-youtube-dislikes
    search-by-image
    seventv
    sponsorblock
    steam-database
    stylus
    ublock-origin
    user-agent-string-switcher
    violentmonkey
  ];

  force = true;

  settings."addon@darkreader.org".settings = {
    syncSettings = true;
  };
}
