let
  loadPreset = path: path |> builtins.readFile |> builtins.fromJSON;
  hexa = loadPreset ./output/Hexa.json;
  mic = loadPreset ./input/Mic.json;
in
{
  services.easyeffects = {
    enable = true;
    preset = {
      input = "Mic";
      output = "Hexa";
    };
    extraPresets = {
      Hexa = {
        inherit (hexa) output;
      };
      Mic = {
        inherit (mic) input;
      };
    };
  };
}
