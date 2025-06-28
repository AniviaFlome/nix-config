{ inputs, system, ... }:

{
  packages = with inputs.firefox-addons.packages."${system}"; [
    augmented-steam
    buster-captcha-solver
    clearurls
    darkreader
    jump-cutter
#     languagetool
    proton-pass
    protondb-for-steam
    return-youtube-dislikes
    search-by-image
    sponsorblock
    steam-database
    stylus
    user-agent-string-switcher
    violentmonkey
    ublock-origin
  ];
}
