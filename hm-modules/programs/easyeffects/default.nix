let
  loadPreset = path: path |> builtins.readFile |> builtins.fromJSON;
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
