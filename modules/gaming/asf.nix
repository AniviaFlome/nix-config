{
   services.archisteamfarm = {
     enable = true;
     web-ui.enable = true;
     settings = {
       Headless = false;
       s_SteamOwnerID = "76561198889718025";
     };
     bots = {
       Anivia = {
        enabled = false;
        passwordFile = "/var/lib/archisteamfarm/secrets/password";
        username = "ztopraks1";
       };
     };
   };
}
