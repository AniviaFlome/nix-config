{
  pkgs,
  ...
}:
{
  programs.nvf.settings.vim = {
    mini.icons.enable = true;
    mini.ai.enable = true;
    mini.indentscope = {
      enable = true;
      setupOpts.ignore_filetypes = [
        "neo-tree"
        "alpha"
        "dashboard"
        "toggleterm"
      ];
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autopairs.nvim-autopairs.enable = true;
    comments.comment-nvim.enable = true;
    filetree.neo-tree.enable = true;
    notes.todo-comments.enable = true;

    visuals.indent-blankline.enable = true;

    treesitter = {
      context.enable = true;
      textobjects.enable = true;
    };

    utility = {
      surround.enable = true;
      oil-nvim.enable = true;
      motion.flash-nvim.enable = true;
      snacks-nvim = {
        enable = true;
        setupOpts = {
          notifier.enabled = true;
          bigfile.enabled = true;
          quickfile.enabled = true;
          words.enabled = true;
          bufdelete.enabled = true;
          terminal.enabled = true;
          picker.enabled = true;
        };
      };
    };

    tabline.nvimBufferline = {
      enable = true;
      setupOpts.options.numbers = "none";
      mappings = {
        cycleNext = "<S-l>";
        cyclePrevious = "<S-h>";
        closeCurrent = "<leader>bd";
      };
    };

    terminal.toggleterm = {
      enable = true;
      setupOpts.direction = "float";
      lazygit = {
        enable = true;
        direction = "float";
      };
    };

    ui = {
      colorizer.enable = true;
      noice.enable = true;
      nvim-ufo.enable = true;
    };

    dashboard.alpha = {
      enable = true;
      theme = "dashboard";
    };

    git = {
      enable = true;
      gitsigns = {
        enable = true;
        setupOpts.signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };
      };
    };

    lsp.trouble = {
      enable = true;
      mappings = {
        documentDiagnostics = "<leader>xx";
        workspaceDiagnostics = "<leader>xX";
        quickfix = "<leader>xq";
        locList = "<leader>xl";
        symbols = "<leader>cs";
        lspReferences = "<leader>cR";
      };
    };

    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      setupOpts = {
        keymap.preset = "default";
        completion.documentation = {
          auto_show = false;
          auto_show_delay_ms = 500;
        };
        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
        signature.enabled = true;
      };
    };

    extraPlugins = with pkgs.vimPlugins; {
      cheatsheet = {
        package = cheatsheet-nvim;
        setup = ''
          require('cheatsheet').setup {
            bundled_cheatsheets = true,
            bundled_plugin_cheatsheets = true,
            include_only_installed_plugins = true,
          }
        '';
      };
      opencode = {
        package = opencode-nvim;
      };
      smear-cursor = {
        package = smear-cursor-nvim;
        setup = "require('smear_cursor').setup {}";
      };
    };
  };
}
