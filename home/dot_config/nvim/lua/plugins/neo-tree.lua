-- ~/.config/nvim/lua/plugins/neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- Do NOT put netrw-disables here; keep them at the TOP of init.lua.
    vim.g.neo_tree_remove_legacy_commands = 1

    require("neo-tree").setup({
      close_if_last_window = false,      -- close if Neo-tree is literally the only win
      open_files_in_last_window = true, -- open files where you were working
      window = {
        position = "left",              -- ALWAYS left
        width = 32,
        preserve_window_proportions = true,
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        -- Let our autocmd handle startup; prevents double-open on `nvim .`
        hijack_netrw_behavior = "disabled",
      },
    })

    -- Keep tree open: reveal/focus instead of toggling it off
    vim.keymap.set(
      "n",
      "<C-n>",
      ":Neotree left reveal<CR>",
      { silent = true, desc = "Neo-tree: reveal/focus (left)" }
    )
    vim.keymap.set(
      "n",
      "<leader>bf",
      ":Neotree buffers reveal float<CR>",
      { silent = true, desc = "Neo-tree: buffers (float)" }
    )

    -- Ensure: exactly ONE normal edit window on the right (no floats), plus the left tree
    local function seat_layout()
      -- Show/focus the tree on the left
      require("neo-tree.command").execute({
        action   = "show",
        source   = "filesystem",
        position = "left",
        reveal   = true,
        toggle   = false,
      })

      -- Collect non-neo-tree (edit) windows; ignore floats
      local edit_wins = {}
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local cfg = vim.api.nvim_win_get_config(win)
        if not cfg.relative or cfg.relative == "" then
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if ft ~= "neo-tree" then
            table.insert(edit_wins, win)
          end
        end
      end

      if #edit_wins == 0 then
        -- Create exactly one edit window on the right
        vim.cmd("vsplit")
        vim.cmd("wincmd l")
        if vim.bo.filetype == "neo-tree" then
          vim.cmd("enew")
        end
      else
        -- Keep focus in the rightmost non-tree window
        vim.cmd("wincmd l")
        if vim.bo.filetype == "neo-tree" then
          -- If rightmost is still the tree (rare), create a right edit pane
          vim.cmd("vsplit")
          vim.cmd("wincmd l")
          if vim.bo.filetype == "neo-tree" then
            vim.cmd("enew")
          end
        end
        -- Close any extra non-tree windows (keep current)
        local keep = vim.api.nvim_get_current_win()
        for _, win in ipairs(edit_wins) do
          if win ~= keep then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
      end
    end

    vim.api.nvim_create_user_command("NeoTreeFixLayout", function()
      vim.schedule(function() pcall(seat_layout) end)
    end, {})

    vim.keymap.set("n", "<leader>et", ":NeoTreeFixLayout<CR>", { silent = true, desc = "Re-seat Neo-tree layout" })

    -- Startup: when `nvim .` (dir) or no args, enforce the layout once UI is ready.
    local grp = vim.api.nvim_create_augroup("NeoTreeStartup", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = grp,
      once  = true,  -- avoid duplicate runs
      callback = function(args)
        local is_dir = (args and args.file ~= "" and vim.fn.isdirectory(args.file) == 1)
        if is_dir or vim.fn.argc() == 0 then
          vim.schedule(function()
            pcall(seat_layout)  -- guard against transient win ids during startup
          end)
        end
      end,
    })
  end,
}
