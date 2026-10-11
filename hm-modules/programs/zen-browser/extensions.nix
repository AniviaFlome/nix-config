{
  pkgs,
  filterLists,
  ...
}:
let
  alwaysVisible = pkgs.firefox-addons.buildFirefoxXpiAddon {
    pname = "always-visible";
    version = "0.4.6";
    addonId = "{4b7825da-0dd1-44f9-9717-bee5b2408af6}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4641852/always_visible-0.4.6.xpi";
    sha256 = "1f9c4d38e130f01edbfe63401c2efdb3ba364738043d578b4ab6c09626b91419";
    meta = with pkgs.lib; {
      homepage = "https://webextension.org/listing/always-active.html";
      description = "Pretend that all browser windows are active by spoofing the visibility state event";
      license = licenses.mpl20;
      mozPermissions = [
        "storage"
        "scripting"
        "*://*/*"
      ];
      platforms = platforms.all;
    };
  };

  redditUnhider = pkgs.firefox-addons.buildFirefoxXpiAddon {
    pname = "reddit-unhider";
    version = "1.0.4";
    addonId = "reddit-unhider@siddh.dev";
    url = "https://addons.mozilla.org/firefox/downloads/file/4813095/reddit_unhider-1.0.4.xpi";
    sha256 = "76d60b1143a3f90baff399013ffcae5b5ad3b07fb9a8db020105585b0e07fd6a";
    meta = with pkgs.lib; {
      homepage = "https://addons.mozilla.org/en-US/firefox/addon/reddit-unhider/";
      description = "Seamlessly explore hidden user profiles, read deleted comments, and view removed posts natively within the interface on Reddit.com.";
      license = licenses.gpl3Only;
      mozPermissions = [
        "webNavigation"
        "*://*.reddit.com/*"
        "https://arctic-shift.photon-reddit.com/*"
      ];
      platforms = platforms.all;
    };
  };
in
{
  packages = with pkgs.firefox-addons; [
    alwaysVisible
    augmented-steam
    buster-captcha-solver
    darkreader
    indie-wiki-buddy
    jump-cutter
    proton-pass
    proton-vpn
    protondb-for-steam
    redditUnhider
    return-youtube-dislikes
    search-by-image
    seventv
    sponsorblock
    steam-database
    stylus
    ublock-origin
    user-agent-string-switcher
    violentmonkey
    zotero-connector
  ];

  force = true;

  settings = {
    "addon@darkreader.org".settings = {
      syncSettings = true;
      syncSitesFixes = false;
      enableForPDF = true;
      detectDarkTheme = true;
      enableForProtectedPages = false;
      previewNewDesign = true;
      previewNewestDesign = false;
      enableContextMenus = false;
      displayedNews = [ "google-docs-bugs" ];
      changeBrowserTheme = false;
      schemeVersion = 2;
      presets = [ ];
      fetchNews = true;
      theme = {
        engine = "dynamicTheme";
        darkSchemeBackgroundColor = "#1e1e2e";
        darkSchemeTextColor = "#cdd6f4";
        lightSchemeBackgroundColor = "#dcdad7";
        lightSchemeTextColor = "#181a1b";
        scrollbarColor = "";
        selectionColor = "#585b70";
      };
      enabledByDefault = false;
      enabled = true;
    };

    "uBlock0@raymondhill.net".settings = {
      showIconBadge = false;
      cloudStorageEnabled = true;
      advancedUserEnabled = true;
      uiAccentCustom = true;
      uiAccent = "#cba7f6";
      selectedFilterLists = filterLists;
    };

    "sponsorBlocker@ajay.app".settings = {
      changeChapterColor = true;
      chapterCategoryAdded = true;
      autoSkipOnMusicVideosUpdate = true;
      dontShowNotice = true;
      permissions = {
        sponsor = true;
        selfpromo = true;
        exclusive_access = true;
        interaction = true;
        intro = true;
        outro = true;
        preview = true;
        hook = true;
        music_offtopic = true;
        filler = true;
        poi_highlight = true;
        chapter = false;
      };
    };

    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}".settings = {
      disableVoteSubmission = false;
      disableLogging = true;
      coloredThumbs = false;
      coloredBar = false;
      colorTheme = false;
      numberDisplayFormat = "compactShort";
      showTooltipPercentage = false;
      tooltipPercentageMode = "dash_like";
      numberDisplayReformatLikes = false;
      registrationConfirmed = true;
    };

    "firefox-extension@steamdb.info".settings = {
      enhancement-skip-agecheck = true;
      enhancement-no-linkfilter = true;
      enhancement-hide-mobile-app-button = false;
    };
  };
}
