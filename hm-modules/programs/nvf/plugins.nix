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
        "snacks_dashboard"
        "toggleterm"
      ];
    };

    statusline.lualine.enable = true;
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
          explorer = {
            enabled = true;
            replace_netrw = true;
          };
          dashboard = {
            enabled = true;
            preset.keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.dashboard.pick('files')";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.dashboard.pick('oldfiles')";
              }
              {
                icon = " ";
                key = "g";
                desc = "Find Text";
                action = ":lua Snacks.dashboard.pick('live_grep')";
              }
              {
                icon = " ";
                key = "e";
                desc = "Explorer";
                action = ":lua Snacks.explorer()";
              }
              {
                icon = " ";
                key = "p";
                desc = "Open Project";
                action = ":lua Snacks.picker.projects()";
              }
              {
                icon = " ";
                key = "s";
                desc = "Restore Session";
                action = ":lua require('persistence').load()";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ];
            sections = [
              { section = "header"; }
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
              {
                icon = " ";
                title = "Recent Files";
                section = "recent_files";
                indent = 2;
                padding = 1;
              }
              {
                icon = " ";
                title = "Projects";
                section = "projects";
                indent = 2;
                padding = 1;
              }
            ];
          };
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
      persistence = {
        package = persistence-nvim;
        setup = "require('persistence').setup {}";
      };
      smear-cursor = {
        package = smear-cursor-nvim;
        setup = "require('smear_cursor').setup {}";
      };
    };
  };
}
