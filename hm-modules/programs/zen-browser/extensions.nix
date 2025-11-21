{
  pkgs,
  ...
}:
{
  packages = with pkgs.firefox-addons; [
    augmented-steam
    buster-captcha-solver
    clearurls
    darkreader
    jump-cutter
    languagetool
    proton-pass
    protondb-for-steam
    return-youtube-dislikes
    search-by-image
    seventv
    sponsorblock
    steam-database
    stylus
    user-agent-string-switcher
    violentmonkey
    ublock-origin
  ];

  force = true;

  settings."addon@darkreader.org".settings = {
    syncSettings = true;
  };
}
