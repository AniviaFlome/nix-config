{
  pkgs,
  ide-font,
  ...
}:
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
      "git-firefly"
      "justfile"
      "nix"
      "nu"
      "toml"
    ];
    userSettings = {
      buffer_font_family = ide-font;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      hour_format = "hour24";
      base_keymap = "VSCode";
      lsp = {
        "nil" = {
          settings = {
            nix.flake = {
              autoArchive = false;
              autoEvalInputs = false;
            };
          };
        };
      };
      languages = {
        Nix = {
          language_servers = [
            "nil"
            "nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
              arguments = [
                "--quiet"
                "--"
              ];
            };
          };
        };
      };
    };
  };
}
