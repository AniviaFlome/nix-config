{
  inputs,
  ...
}:
{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        options = {
          number = true;
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
        };
        undoFile.enable = true;
        clipboard.enable = true;
        statusline.lualine.enable = true;
        telescope.enable = true;
        utility.surround.enable = true;
        globals = {
          mapleader = " ";
          maplocalleader = " ";
          have_nerd_font = true;
        };
        spellcheck = {
          enable = true;
          languages = [
            "en"
            "tr"
          ];
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
        lsp = {
          enable = true;
          inlayHints.enable = true;
          formatOnSave = true;
        };
        languages = {
          enableFormat = true;
          enableTreesitter = true;

          nix.enable = true;
          markdown.enable = true;
          lua.enable = true;
          bash.enable = true;
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
        binds.whichKey = {
          enable = true;
          setupOpts = {
            delay = 0;
            spec = [
              {
                __unkeyed-1 = "<leader>s";
                group = "[S]earch";
                mode = [
                  "n"
                  "v"
                ];
              }
              {
                __unkeyed-1 = "<leader>t";
                group = "[T]oggle";
              }
              {
                __unkeyed-1 = "<leader>h";
                group = "Git [H]unk";
                mode = [
                  "n"
                  "v"
                ];
              }
            ];
          };
        };
        keymaps = [
          {
            key = "<Esc>";
            mode = "n";
            action = "<cmd>nohlsearch<CR>";
            desc = "Clear search highlights";
          }
          {
            key = "<leader>q";
            mode = "n";
            action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
            desc = "Open diagnostic [Q]uickfix list";
          }
          {
            key = "<Esc><Esc>";
            mode = "t";
            action = "<C-\\><C-n>";
            desc = "Exit terminal mode";
          }
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
          {
            key = "<leader>f";
            mode = "";
            action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<CR>";
            desc = "[F]ormat buffer";
          }
          {
            key = "<leader>th";
            mode = "n";
            action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
            desc = "[T]oggle Inlay [H]ints";
          }
        ];

        luaConfigRC.kickstart-extras = ''
          vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

          local yank_group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true })
          vim.api.nvim_create_autocmd('TextYankPost', {
            desc = 'Highlight when yanking (copying) text',
            group = yank_group,
            callback = function() vim.hl.on_yank() end,
          })

          vim.diagnostic.config({
            update_in_insert = false,
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = vim.diagnostic.severity.ERROR },
            virtual_text = true,
            virtual_lines = false,
            jump = { float = true },
          })
        '';
      };
    };
  };
}
