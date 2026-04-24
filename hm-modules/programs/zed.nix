{
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      nixd
      nixfmt
    ];
    extensions = [
      "env"
      "fish"
      "git-firefly"
      "github-actions"
      "ini"
      "justfile"
      "kdl"
      "log"
      "lua"
      "nix"
      "nu"
      "opencode"
      "powershell"
      "rainbow-csv"
      "toml"
      "xml"
    ];
    enableMcpIntegration = true;
    userSettings = {
      buffer_font_family = "CascaydiaMono Nerd Font";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      hour_format = "hour24";
      base_keymap = "VSCode";
      colorize_brackets = true;
      disable_agent = false;
      lsp = {
        "nil".settings = {
          nix.flake = {
            autoArchive = false;
            autoEvalInputs = false;
          };
        };
      };
      languages = {
        Markdown = {
          language_servers = [ "marksman" ];
        };
        Nix = {
          language_servers = [
            "nil"
            "nixd"
          ];
          formatter.external = {
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
}
