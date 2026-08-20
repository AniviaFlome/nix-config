{
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      cargo
      marksman
      nil
      nixd
      nixfmt
      rust-analyzer
      rustc
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
    userTasks = [
      {
        label = "json2nix";
        command = "nix eval --impure --expr 'builtins.fromJSON (builtins.getEnv \"ZED_SELECTED_TEXT\")' | nix-shell -p wl-clipboard --run wl-copy";
        use_new_terminal = false;
        hide = "on_success";
      }
    ];
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
