{ inputs, ... }:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = false;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          };
        statusline.lualine = {
          enable = true;
        };
        telescope = {
          enable = true;
        };
        autocomplete.nvim-cmp = {
          enable = true;
        };
        languages = {
          enableLSP = true;
          enableTreesitter = true;
          nix.enable = true;
        };
      };
    };
  };
}
