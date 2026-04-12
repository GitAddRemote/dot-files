return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.ts",
          env = { CI = "true" },
          cwd = function() return vim.loop.cwd() end,
        }),
      },
    })

    vim.keymap.set("n", "<leader>t", function() require("neotest").run.run() end, { desc = "Neotest: run nearest" })
    vim.keymap.set("n", "<leader>T", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Neotest: run file" })
    vim.keymap.set("n", "<leader>a", function() require("neotest").run.run(vim.loop.cwd()) end, { desc = "Neotest: run suite" })
    vim.keymap.set("n", "<leader>l", function() require("neotest").run.run_last() end, { desc = "Neotest: run last" })
    vim.keymap.set("n", "<leader>to", function() require("neotest").output_panel.toggle() end, { desc = "Neotest: toggle output panel" })
    vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Neotest: toggle summary" })
  end,
}
