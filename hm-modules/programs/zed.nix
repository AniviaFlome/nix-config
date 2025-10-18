{ pkgs, ide-font, ... }:

{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      nixd
    ];
    extensions = [
      "env"
      "fish"
      "justfile"
      "nix"
      "nu"
      "toml"
    ];
    userSettings = {
      buffer_font_family = "${ide-font}";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };
}
