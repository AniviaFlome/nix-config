{
  programs.nvf.settings.vim.luaConfigRC = {
    kickstart-extras = ''
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
        jump = { on_jump = "float" },
      })
    '';

    neotree-autoopen = ''
      vim.api.nvim_create_autocmd('VimEnter', {
        desc = 'Open Neo-tree when opening files',
        callback = function()
          if vim.fn.argc() > 0 then
            vim.cmd('Neotree show')
            vim.cmd('wincmd p')
          end
        end,
      })
    '';

    right-arrow-accept = ''
      local function right_arrow_accept(mode)
        return function()
          local ok, cmp = pcall(require, 'blink.cmp')
          if ok and cmp.is_visible() then
            cmp.accept()
          else
            local key = vim.api.nvim_replace_termcodes('<Right>', true, false, true)
            vim.api.nvim_feedkeys(key, 'n', false)
          end
        end
      end
      vim.keymap.set('i', '<Right>', right_arrow_accept('i'))
      vim.keymap.set('c', '<Right>', right_arrow_accept('c'))
    '';

    alpha-custom-buttons = ''
      local ok, _ = pcall(function()
        local dashboard = require('alpha.themes.dashboard')

        dashboard.section.buttons.val = {
          dashboard.button("f", "  Find file",    ":Telescope find_files <CR>"),
          dashboard.button("n", "  New file",     ":ene <BAR> startinsert <CR>"),
          dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
          dashboard.button("g", "  Find text",    ":Telescope live_grep <CR>"),
          dashboard.button("p", "  Open project", ":lua Snacks.picker.projects()<CR>"),
          dashboard.button("q", "  Quit",         ":qa<CR>"),
        }
        require('alpha').setup(dashboard.config)
      end)
    '';

    custom-autocmds = ''
      -- Restore cursor position on file open
      vim.api.nvim_create_autocmd('BufReadPost', {
        callback = function(args)
          local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
          local lcount = vim.api.nvim_buf_line_count(args.buf)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end,
      })

      -- Disable auto-comment continuation on newline
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
        end,
      })

      -- Auto-toggle relative numbers (relative in normal, absolute in insert)
      local numgroup = vim.api.nvim_create_augroup('numbertoggle', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
        group = numgroup,
        callback = function()
          if vim.wo.number then vim.wo.relativenumber = true end
        end,
      })
      vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
        group = numgroup,
        callback = function()
          if vim.wo.number then vim.wo.relativenumber = false end
        end,
      })
    '';
  };
}
