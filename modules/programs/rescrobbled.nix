{
  flake.modules.homeManager.rescrobbled =
    { config, ... }:
    {
      services.rescrobbled = {
        enable = true;
        settings = {
          player-whitelist = [

          ];
          listenbrainz = [
            {
              token-file = config.sops.secrets."listenbrainz-token".path;
            }
          ];
        };
      };
    };
}
