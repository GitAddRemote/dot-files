return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  ft = "json",
  config = function()
    require("package-info").setup({ autostart = true })

    vim.keymap.set("n", "<leader>ns", require("package-info").show, { silent = true, desc = "package-info: show versions" })
    vim.keymap.set("n", "<leader>nh", require("package-info").hide, { silent = true, desc = "package-info: hide versions" })
    vim.keymap.set("n", "<leader>nu", require("package-info").update, { silent = true, desc = "package-info: update package" })
    vim.keymap.set("n", "<leader>nd", require("package-info").delete, { silent = true, desc = "package-info: delete package" })
    vim.keymap.set("n", "<leader>ni", require("package-info").install, { silent = true, desc = "package-info: install package" })
    vim.keymap.set("n", "<leader>nv", require("package-info").change_version, { silent = true, desc = "package-info: change version" })
  end,
}
