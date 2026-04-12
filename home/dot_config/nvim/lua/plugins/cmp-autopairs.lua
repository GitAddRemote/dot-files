-- lua/plugins/cmp-autopairs.lua
return {
  "hrsh7th/nvim-cmp",
  dependencies = { "windwp/nvim-autopairs" },
  config = function(_, opts)
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- load existing cmp config first (LazyVim already provides it)
    cmp.setup(opts)

    -- hook autopairs into cmp confirm event
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
