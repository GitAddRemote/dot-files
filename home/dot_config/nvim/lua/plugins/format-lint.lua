return {
  -- Formatting via Prettier/Prettierd
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        jsonc = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        scss = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        graphql = { "prettierd", "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format file" },
    },
  },

  -- Linting via ESLint (eslint_d) with robust cwd detection for monorepos
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local util = require("lint.util")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- Find nearest project root that has an ESLint config; fall back to git or CWD
      local patterns = {
        -- flat config
        "eslint.config.js", "eslint.config.cjs", "eslint.config.mjs", "eslint.config.ts",
        -- legacy configs
        ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.mjs", ".eslintrc.json", ".eslintrc",
        -- fallbacks
        "package.json", ".git",
      }

      lint.linters.eslint_d.cwd = function(bufnr)
        return util.find_nearest(bufnr, patterns) or vim.loop.cwd()
      end

      -- IMPORTANT: args must be a list of strings OR a function returning that list
      lint.linters.eslint_d.args = function(ctx)
        return {
          "--format", "json",
          "--stdin",
          "--stdin-filename", ctx.filename,
          "--max-warnings", "0",
        }
      end

      -- Run lint on save/leave insert/when opening a buffer
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
        callback = function()
          local ft = vim.bo.filetype
          if lint.linters_by_ft[ft] then
            lint.try_lint()
          end
        end,
      })

      vim.keymap.set("n", "<leader>cl", function() lint.try_lint() end, { desc = "Run lint" })
    end,
  },

  -- Auto-install external tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = { "prettierd", "prettier", "eslint_d" },
      auto_update = false,
      run_on_start = true,
    },
  },
}
