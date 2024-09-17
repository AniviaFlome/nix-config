{ config, pkgs, ... }:

{
  programs.qutebrowser = {
    enable = true;
    settings = {
      content = {
        cookies = {
          accept = "no";
          third-party = "no";
          domain-accept = [
https://github.com
https://kick.com
https://auth.openai.com
https://www.youtube.com
https://www.chess.com
https://melvoridle.com
https://x.com
https://osu.ppy.sh
https://mail.google.com
https://myanimelist.net
https://btt.community
https://proxy2.webshare.io
https://newreleases.io
https://www.netflix.com
https://cs.rin.ru
https://coinmarketcap.com
https://www.twitch.tv
https://www.minecraft.net
https://app.simplelogin.io
https://duckduckgo.com
https://anilist.co
https://store.steampowered.com
https://diziwatch.net
https://www.instagram.com
https://lichess.org
https://www.reddit.com
https://steamcommunity.com
https://www.amazon.com.tr
https://iosgods.com
https://web.whatsapp.com
https://gaming.amazon.com
https://accounts.google.com
https://www.turkanime.co
https://hianime.to
https://www.gog.com
https://auth.ente.io
https://cobalt.tools
https://store.epicgames.com
https://www.braflix.ru
          ];
        };
      };
    };
  };
}
