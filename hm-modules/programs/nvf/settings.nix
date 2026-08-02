{
  programs.nvf.settings.vim = {
    options = {
      number = true;
      relativenumber = true;
      mouse = "a";
      showmode = false;
      breakindent = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      cursorline = true;
      scrolloff = 10;
      confirm = true;
      inccommand = "split";
      swapfile = false;
      backup = false;
      tabstop = 2;
      shiftwidth = 2;
      smarttab = true;
      smartindent = true;
      termguicolors = true;
      conceallevel = 3;
      laststatus = 3;
      wrap = false;
      foldenable = true;
      foldlevel = 99;
      foldlevelstart = 99;
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    undoFile.enable = true;
    clipboard.enable = true;

    spellcheck = {
      enable = true;
      languages = [
        "en"
        "tr"
      ];
    };
  };
}
