{ pkgs, ... }:

{
  #imports = [ ./cookie.nix ];

  programs.qutebrowser = {
    enable = true;
    settings = {
      colors.webpage.darkmode.enabled = true;
      colors.webpage.preferred_color_scheme = "dark";

    };
    keyBindings = {
      normal = {
        "td" = "config-cycle colors.webpage.darkmode.enabled";
      };
    };
    searchEngines = {
      ddg = "https://duckduckgo.com/?q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      g = "https://www.google.com/search?hl=en&q={}";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://wiki.nixos.org/index.php?search={}";
      np = "https://search.nixos.org/packages?q={}";
      hm = "https://home-manager-options.extranix.com/?query={}&release=master";
    };
    greasemonkey = [
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/1d1be041a65c251692ee082eda64d2637edf6444/youtube_sponsorblock.js";
        sha256 = "sha256-e3QgDPa3AOpPyzwvVjPQyEsSUC9goisjBUDMxLwg8ZE=";
      })
      (pkgs.fetchurl {
        url = "https://github.com/iamfugui/youtube-adb/raw/main/index.user.js";
        sha256 = "0xlr2a9m4qdm2nnxzcz602pykk021hqhiriavlhkq628mnb7fwcb";
      })
    ];
    extraConfig = ''
      import os
      from urllib.request import urlopen

      # load your autoconfig, use this, if the rest of your config is empty!
      config.load_autoconfig()

      if not os.path.exists(config.configdir / "theme.py"):
          theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
          with urlopen(theme) as themehtml:
              with open(config.configdir / "theme.py", "a") as file:
                  file.writelines(themehtml.read().decode("utf-8"))

      if os.path.exists(config.configdir / "theme.py"):
          import theme
          theme.setup(c, 'mocha', True)
    '';
  };
}
