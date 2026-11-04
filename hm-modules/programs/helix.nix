{
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = false;
    extraPackages = with pkgs; [
      marksman
      nil
      nixd
      nixfmt
    ];
    settings = {
      editor = {
        line-number = "relative";
        mouse = true;
        color-modes = true;
        cursorline = true;
        auto-pairs = true;
        auto-completion = true;
        auto-format = true;
        bufferline = "multiple";
        indent-guides.render = true;
        soft-wrap.enable = true;
      };
      keys.normal = {
        "C-t" =
          ":pipe bash -c 'nix eval --impure --expr ''builtins.fromJSON (builtins.readFile \"/dev/stdin\")'' | tee >(wl-copy)'";
      };
    };

    languages = {
      language-server.nil.config.nix.flake = {
        autoArchive = false;
        autoEvalInputs = false;
      };
      language = [
        {
          name = "nix";
          language-servers = [
            "nil"
            "nixd"
          ];
          formatter = {
            command = "nixfmt";
            args = [
              "--quiet"
              "--"
            ];
          };
          auto-format = true;
        }
        {
          name = "markdown";
          language-servers = [ "marksman" ];
        }
      ];
    };
  };
}
