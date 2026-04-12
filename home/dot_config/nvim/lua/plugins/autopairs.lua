return {
  -- Autopairs + cmp integration + Treesitter awareness
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {},

        -- 👇 Treesitter-aware pairing
        check_ts = true,
        ts_config = {
          lua = { "string" },            -- don't auto-pair inside lua strings
          javascript = { "template_string" },
          typescript = { "template_string" },
          -- java = false,               -- example: disable TS checks for a lang
        },
      })

      -- Hook into nvim-cmp so confirming functions adds "()"
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- <leader>ha → small help popup
      vim.keymap.set("n", "<leader>ha", function()
        vim.notify([[
nvim-autopairs shortcuts:

- Type ()[]{}""'' to auto-close pairs
- Confirm completion → adds () for functions
- <M-e> (Alt+e) in Insert mode → fast wrap surrounding text
        ]], vim.log.levels.INFO, { title = "Autopairs Help" })
      end, { desc = "Show autopairs keymap hints" })
    end,
  },

  -- Ensure useful Tree-sitter parsers are installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      local want = {
        "typescript", "tsx", "javascript", "json",
        "lua", "html", "css", "bash", "yaml", "toml",
      }
      for _, lang in ipairs(want) do
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
    end,
  },
}
