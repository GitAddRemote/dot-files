-- Built-in Diagnostics UX (no external plugins)
-- Auto-popup on hover + handy keymaps
-- - Hover (pause cursor) -> diagnostic float
-- - gl  -> show diagnostic float now
-- - [d  -> previous diagnostic
-- - ]d  -> next diagnostic
-- - <leader>q -> diagnostics to loclist
-- - :DiagnosticsTogglePopup -> toggle auto-popup

return {
  -- Use plenary as a harmless anchor so Lazy treats this as a plugin spec
  "nvim-lua/plenary.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    -- Nice defaults for diagnostics
    vim.diagnostic.config({
      virtual_text = true,          -- set false if you dislike inline text
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
    })

    -- Keys
    vim.keymap.set("n", "gl", function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        border = "rounded",
        source = "always",
        scope = "cursor",
      })
    end, { desc = "Diagnostics: show float" })

    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostics: previous" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostics: next" })
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics: to loclist" })

    -- ---- Auto-popup on hover (ON by default) ----
    local GROUP = "DiagnosticsFloat"
    local function enable_popup()
      -- Faster hover: only lower it, don't increase if user already set smaller
      vim.o.updatetime = math.min(vim.o.updatetime, 300)
      vim.api.nvim_create_augroup(GROUP, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = GROUP,
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false,
            border = "rounded",
            source = "if_many",
            scope = "cursor",
          })
        end,
      })
    end

    local function disable_popup()
      pcall(vim.api.nvim_del_augroup_by_name, GROUP)
    end

    -- Default: ON (flip with :DiagnosticsTogglePopup)
    vim.g.diagnostics_auto_popup = true
    enable_popup()

    vim.api.nvim_create_user_command("DiagnosticsTogglePopup", function()
      vim.g.diagnostics_auto_popup = not vim.g.diagnostics_auto_popup
      disable_popup()
      if vim.g.diagnostics_auto_popup then enable_popup() end
      vim.notify("Diagnostics popup: " .. (vim.g.diagnostics_auto_popup and "ON" or "OFF"))
    end, {})
  end,
}
