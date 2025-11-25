let
  loadPreset = path: builtins.fromJSON (builtins.readFile path);
in
{
  services.easyeffects = {
    enable = true;
    preset = "Hexa";
    extraPresets = {
      main = loadPreset ./output/Hexa.json;
    };
  };
}
