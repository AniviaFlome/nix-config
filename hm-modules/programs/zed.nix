{
  config,
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
      "lua"
      "mcp-server-github"
      "nix"
      "nu"
      "opencode"
      "powershell"
      "rainbow-csv"
      "toml"
      "xml"
    ];
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
      context_servers = {
        "mcp-server-github" = {
          enabled = true;
          remote = false;
          settings = {
            github_personal_access_token = config.sops.secrets."github-mcp".path;
          };
        };
      };
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
