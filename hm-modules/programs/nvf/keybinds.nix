{
  programs.nvf.settings.vim = {
    binds.whichKey = {
      enable = true;
      setupOpts.delay = 0;
    };

    keymaps = [
      # General
      {
        key = "<Esc>";
        mode = "n";
        action = "<cmd>nohlsearch<CR>";
        desc = "Clear search highlights";
      }
      {
        key = "<leader>w";
        mode = "n";
        action = "<cmd>w<CR>";
        desc = "[W]rite buffer";
      }
      {
        key = "<leader>S";
        mode = "n";
        action = ":%s//g<Left><Left>";
        desc = "[S]earch and replace in file";
      }
      {
        key = "<Esc><Esc>";
        mode = "t";
        action = "<C-\\><C-n>";
        desc = "Exit terminal mode";
      }

      # Window navigation
      {
        key = "<C-h>";
        mode = "n";
        action = "<C-w><C-h>";
        desc = "Move focus to the left window";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<C-w><C-l>";
        desc = "Move focus to the right window";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<C-w><C-j>";
        desc = "Move focus to the lower window";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<C-w><C-k>";
        desc = "Move focus to the upper window";
      }

      # Window resize
      {
        key = "<F5>";
        mode = "n";
        action = "<cmd>vertical resize -2<CR>";
        desc = "Decrease window width";
      }
      {
        key = "<F6>";
        mode = "n";
        action = "<cmd>vertical resize +2<CR>";
        desc = "Increase window width";
      }
      {
        key = "<F7>";
        mode = "n";
        action = "<cmd>resize -2<CR>";
        desc = "Decrease window height";
      }
      {
        key = "<F8>";
        mode = "n";
        action = "<cmd>resize +2<CR>";
        desc = "Increase window height";
      }

      # Telescope / Search (Kickstart style <leader>s*)
      {
        key = "<leader>sh";
        mode = "n";
        action = "<cmd>Telescope help_tags<CR>";
        desc = "[S]earch [H]elp";
      }
      {
        key = "<leader>sk";
        mode = "n";
        action = "<cmd>Telescope keymaps<CR>";
        desc = "[S]earch [K]eymaps";
      }
      {
        key = "<leader>sf";
        mode = "n";
        action = "<cmd>Telescope find_files<CR>";
        desc = "[S]earch [F]iles";
      }
      {
        key = "<leader>ss";
        mode = "n";
        action = "<cmd>Telescope builtin<CR>";
        desc = "[S]earch [S]elect Telescope";
      }
      {
        key = "<leader>sw";
        mode = "n";
        action = "<cmd>Telescope grep_string<CR>";
        desc = "[S]earch current [W]ord";
      }
      {
        key = "<leader>sg";
        mode = "n";
        action = "<cmd>Telescope live_grep<CR>";
        desc = "[S]earch by [G]rep";
      }
      {
        key = "<leader>sd";
        mode = "n";
        action = "<cmd>Telescope diagnostics<CR>";
        desc = "[S]earch [D]iagnostics";
      }
      {
        key = "<leader>sr";
        mode = "n";
        action = "<cmd>Telescope resume<CR>";
        desc = "[S]earch [R]esume";
      }
      {
        key = "<leader>s.";
        mode = "n";
        action = "<cmd>Telescope oldfiles<CR>";
        desc = "[S]earch Recent Files";
      }
      {
        key = "<leader><leader>";
        mode = "n";
        action = "<cmd>Telescope buffers<CR>";
        desc = "Find existing buffers";
      }
      {
        key = "<leader>/";
        mode = "n";
        action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
        desc = "[/] Fuzzily search in current buffer";
      }
      {
        key = "<leader>sn";
        mode = "n";
        action = "<cmd>Telescope find_files cwd=~/nix-config<CR>";
        desc = "[S]earch [N]ix config files";
      }

      # Projects (<leader>f*)
      {
        key = "<leader>fp";
        mode = "n";
        action = "<cmd>lua Snacks.picker.projects()<CR>";
        desc = "[F]ind [P]rojects";
      }

      # LSP / Code (<leader>c*)
      {
        key = "<C-k>";
        mode = "i";
        action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
        desc = "Signature help (insert)";
      }
      {
        key = "<leader>cf";
        mode = [
          "n"
          "v"
        ];
        action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<CR>";
        desc = "[C]ode [F]ormat buffer";
      }
      {
        key = "<leader>cd";
        mode = "n";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        desc = "[C]ode line [D]iagnostics";
      }
      {
        key = "]d";
        mode = "n";
        action = "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>";
        desc = "Next diagnostic";
      }
      {
        key = "[d";
        mode = "n";
        action = "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>";
        desc = "Previous diagnostic";
      }
      {
        key = "<leader>xq";
        mode = "n";
        action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
        desc = "Open diagnostic [Q]uickfix list";
      }

      # File navigation
      {
        key = "<leader>e";
        mode = "n";
        action = "<cmd>Neotree toggle<CR>";
        desc = "Toggle file [E]xplorer";
      }
      {
        key = "-";
        mode = "n";
        action = "<cmd>Oil<CR>";
        desc = "Open parent directory (Oil)";
      }

      # Cheatsheet
      {
        key = "<leader>?";
        mode = "n";
        action = "<cmd>Cheatsheet<CR>";
        desc = "Open cheatsheet";
      }

      # Buffer group (<leader><tab>*)
      {
        key = "<leader><tab>o";
        mode = "n";
        action = "<cmd>%bd|e#|bd#<CR>";
        desc = "[Tab] Close [O]ther buffers";
      }
      {
        key = "<leader><tab>d";
        mode = "n";
        action = "<cmd>lua Snacks.bufdelete()<CR>";
        desc = "[Tab] Close buffer [D]elete";
      }
      {
        key = "<leader>bd";
        mode = "n";
        action = "<cmd>lua Snacks.bufdelete()<CR>";
        desc = "[B]uffer [D]elete";
      }

      # Quit / session group (<leader>q*)
      {
        key = "<leader>qq";
        mode = "n";
        action = "<cmd>qa<CR>";
        desc = "[Q]uit [Q]uit all";
      }
      {
        key = "<leader>qd";
        mode = "n";
        action = "<cmd>lua Snacks.bufdelete.delete({ wipe = false })<CR>";
        desc = "[Q]uit + [D]rop buffer";
      }

      # Git group (<leader>g*)
      # <leader>gg (lazygit) is bound by vim.terminal.toggleterm.lazygit
      {
        key = "<leader>gb";
        mode = "n";
        action = "<cmd>Gitsigns blame_line<CR>";
        desc = "[G]it [B]lame line";
      }
      {
        key = "<leader>gd";
        mode = "n";
        action = "<cmd>Gitsigns diffthis<CR>";
        desc = "[G]it [D]iff hunk";
      }
      {
        key = "<leader>gR";
        mode = "n";
        action = "<cmd>Gitsigns reset_hunk<CR>";
        desc = "[G]it [R]eset hunk";
      }
      {
        key = "]h";
        mode = "n";
        action = "<cmd>Gitsigns next_hunk<CR>";
        desc = "Next git hunk";
      }
      {
        key = "[h";
        mode = "n";
        action = "<cmd>Gitsigns prev_hunk<CR>";
        desc = "Previous git hunk";
      }

      # UI toggles group (<leader>u*)
      {
        key = "<leader>uw";
        mode = "n";
        action = "<cmd>set wrap!<CR>";
        desc = "[U]I toggle [W]rap";
      }
      {
        key = "<leader>ul";
        mode = "n";
        action = "<cmd>set relativenumber!<CR>";
        desc = "[U]I toggle relative [L]ine numbers";
      }
      {
        key = "<leader>uL";
        mode = "n";
        action = "<cmd>set number!<CR>";
        desc = "[U]I toggle [L]ine numbers";
      }
      {
        key = "<leader>us";
        mode = "n";
        action = "<cmd>set spell!<CR>";
        desc = "[U]I toggle [S]pell";
      }
      {
        key = "<leader>uh";
        mode = "n";
        action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
        desc = "[U]I toggle inlay [H]ints";
      }
      {
        key = "<leader>ud";
        mode = "n";
        action = "<cmd>lua vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })<CR>";
        desc = "[U]I toggle [D]iagnostics";
      }
      {
        key = "<leader>uf";
        mode = "n";
        action = "<cmd>lua vim.lsp.toggle_format_on_save and vim.lsp.toggle_format_on_save()<CR>";
        desc = "[U]I toggle [F]ormat on save";
      }
    ];

    luaConfigRC.whichkey-groups = ''
      local wk_ok, wk = pcall(require, 'which-key')
      if wk_ok then
        wk.add({
          { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
          { "<leader>f", group = "[F]ind/Project" },
          { "<leader>c", group = "[C]ode" },
          { "<leader>g", group = "[G]it" },
          { "<leader>u", group = "[U]I toggle" },
          { "<leader>x", group = "Diagnostics/Trouble" },
          { "<leader>b", group = "[B]uffer" },
          { "<leader><tab>", group = "[Tab] Buffer" },
          { "<leader>q", group = "[Q]uit/Session" },
        })
      end
    '';
  };
}
