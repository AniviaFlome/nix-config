{
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      inlayHints.enable = true;
      formatOnSave = true;

      mappings = {
        goToDefinition = "gd";
        goToDeclaration = "gD";
        goToType = "gy";
        listReferences = "gr";
        listImplementations = "gI";
        hover = "K";
        signatureHelp = "gK";
        renameSymbol = "<leader>cr";
        codeAction = "<leader>ca";
        listDocumentSymbols = "gO";
        openDiagnosticFloat = "<leader>cd";
        nextDiagnostic = "]d";
        previousDiagnostic = "[d";
        format = "<leader>cf";
        toggleFormatOnSave = "<leader>uf";
      };
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
