let
  loadPreset = path: path |> builtins.readFile |> builtins.fromJSON;
in
{
  flake.modules.homeManager.easyeffects = {
    services.easyeffects = {
      enable = true;
      preset = "Hexa";
      extraPresets = {
        main = loadPreset ./output/Hexa.json;
      };
    };
  };
}
