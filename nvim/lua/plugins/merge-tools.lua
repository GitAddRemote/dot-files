--[[
  🔑 Merge Conflict Resolution Keybindings:

  git-conflict.nvim:
    ]x    → Jump to next conflict
    [x    → Jump to previous conflict
    co    → Keep our version
    ct    → Keep their version
    cb    → Keep both versions
    c0    → Keep none

  fugitive.nvim:
    :Gdiffsplit     → 3-way merge view
    :Gwrite         → Mark file as resolved (after editing)

  diffview.nvim:
    :DiffviewOpen   → Open diff view
    :DiffviewClose  → Close diff view
    :DiffviewFileHistory → View file history

  gitsigns.nvim:
    ]c / [c         → Jump between hunks
    <leader>hp      → Preview hunk
    <leader>hb      → Blame line
]]

return {
  -- Essential Git interface
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread", "G" },
  },

  -- Visual diff and merge UI
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({
        use_icons = true,
        view = {
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = true,
          },
        },
        file_panel = {
          win_config = { position = "left", width = 35 },
        },
      })
    end,
  },

  -- Gitsigns for hunk-level indicators
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Conflict resolution plugin with indicators and actions
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    event = "BufReadPre",
    opts = {
      default_mappings = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },
}

