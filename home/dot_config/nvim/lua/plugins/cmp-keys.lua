return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")
    opts = opts or {}
    opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
      ["<C-]>"] = cmp.mapping.complete(),                   -- manual trigger (insert mode)
      ["<CR>"]  = cmp.mapping.confirm({ select = true }),   -- accept selection
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),
    })
    opts.preselect = opts.preselect or cmp.PreselectMode.Item
    return opts
  end,
}
