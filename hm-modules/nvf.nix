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
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
        languages = {
          enableTreesitter = true;
          nix.enable = true;
        };
      };
    };
  };
}
