return {
  -- Core Copilot client
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = true }, -- set true if you want ghost text too
        panel = { enabled = false },
      })
    end,
  },

  -- Bridge Copilot -> cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()

      -- Defer source injection until after cmp is fully set up by other plugins
      vim.schedule(function()
        local ok, cmp = pcall(require, "cmp")
        if not ok then return end

        -- read current sources, prepend Copilot if missing, then reapply
        local sources = cmp.get_config().sources or {}
        local has = false
        for _, s in ipairs(sources) do
          if s.name == "copilot" then has = true break end
        end
        if not has then
          table.insert(sources, 1, { name = "copilot", group_index = 2, priority = 1000 })
          cmp.setup({ sources = sources })
        end
      end)
    end,
  },
}
