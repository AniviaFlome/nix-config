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

      # Telescope / Search
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
        action = "<cmd>Telescope find_files cwd=~/.config/nvim<CR>";
        desc = "[S]earch [N]eovim files";
      }

      # LSP / Diagnostics
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
        key = "<leader>th";
        mode = "n";
        action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
        desc = "[T]oggle Inlay [H]ints";
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

      # Toggles
      {
        key = "<leader>tn";
        mode = "n";
        action = "<cmd>set relativenumber!<CR>";
        desc = "[T]oggle relative [N]umbers";
      }
      {
        key = "<leader>tw";
        mode = "n";
        action = "<cmd>Twilight<CR>";
        desc = "[T]oggle T[w]ilight";
      }
    ];
  };
}
