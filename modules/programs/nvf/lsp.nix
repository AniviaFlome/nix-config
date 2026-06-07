{
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      inlayHints.enable = true;
      formatOnSave = true;
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;

      nix = {
        enable = true;
        lsp.servers = [
          "nil"
          "nixd"
        ];
        format.type = [ "nixfmt" ];
      };
      bash.enable = true;
      lua.enable = true;
      python.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };
    };
  };
}
