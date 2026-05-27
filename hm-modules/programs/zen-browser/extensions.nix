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
    ublock-origin
    user-agent-string-switcher
    violentmonkey
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
      selectedFilterLists = [
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        "easylist"
        "easyprivacy"
        "urlhaus-1"
        "plowe-0"
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
        "tr-0"
      ];
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
