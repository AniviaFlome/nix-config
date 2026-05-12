{
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      marksman
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
      "powershell"
      "rainbow-csv"
      "toml"
      "xml"
    ];
    enableMcpIntegration = true;
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-k" = "editor::Cut";
        };
      }
    ];
    userSettings = {
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      base_keymap = "VSCode";
      colorize_brackets = true;
      disable_ai = false;
      journal = {
        hour_format = "hour24";
      };
      active_pane_modifiers = {
        inactive_opacity = 0.85;
      };
      agent_servers = {
        OpenCode = {
          type = "custom";
          command = "opencode";
          args = [ "acp" ];
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
