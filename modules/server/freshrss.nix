{
  flake.modules.nixos.freshrss =
    { lib, ... }:
    {
      services.freshrss = {
        enable = lib.mkDefault false;
        baseUrl = "https://rss.example.com";
        defaultUser = "admin";
        database.type = "sqlite";
      };
    };
}
