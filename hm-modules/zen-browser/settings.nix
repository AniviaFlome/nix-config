{ username, ... }:

{
  programs.firefox = {
    profiles.${username} = {
      settings = {
"browser.download.autohideButton" = true;
"browser.translations.automaticallyPopup" = false;
"dom.enable_web_task_scheduling" = true;
"full-screen-api.transition-duration.enter" = "0 0";
"full-screen-api.transition-duration.leave" = "0 0";
"full-screen-api.warning.delay" = 0;
"full-screen-api.warning.timeout" = 0;
"general.autoScroll" = true;
"identity.fxaccounts.enabled" = true;
"layout.css.grid-template-masonry-value.enabled" = true;
"media.eme.enabled" = true;
"media.videocontrols.picture-in-picture.video-toggle.has-used" = true;
"middlemouse.paste" = false;
"network.trr.mode" = 3;
"network.trr.uri" = "https://dns.quad9.net/dns-query";
"permissions.default.desktop-notification" = 2;
"security.OCSP.enabled" = 1;
"security.OCSP.require" = true;
"security.pki.crlite_mode" = 2;
"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
"ui.key.menuAccessKeyFocuses" = false;
      };
    };
  };
}
