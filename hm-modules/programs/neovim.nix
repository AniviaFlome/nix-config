{ inputs, ... }:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        lsp.enable = true;
        undoFile.enable = true;
        spellcheck = {
          enable = true;
          languages = [
            "en"
            "tr"
          ];
        };
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          nix.enable = true;
          markdown.enable = true;
        };
      };
    };
  };
}
