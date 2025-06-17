return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    ensure_installed = {
      "tsserver-language-server",
    },
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.gradle_ls.setup({ capabilities = capabilities })
      lspconfig.graphql.setup({ capabilities = capabilities })
      lspconfig.helm_ls.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.java_language_server.setup({ capabilities = capabilities })
      lspconfig.kotlin_language_server.setup({ capabilities = capabilities })
      lspconfig.lemminx.setup({ capabilities = capabilities }) -- XML, XSD, XSL, etc.
      -- lspconfig.lua_ls.setup({ capabilities = capabilities }) -- optional
      lspconfig.r_language_server.setup({ capabilities = capabilities })
      lspconfig.spectral.setup({ capabilities = capabilities }) -- YAML, YML, JSON linting
      lspconfig.sqls.setup({ capabilities = capabilities })
      lspconfig.svelte.setup({ capabilities = capabilities })
      lspconfig.taplo.setup({ capabilities = capabilities }) -- TOML
      lspconfig.terraformls.setup({ capabilities = capabilities })
      lspconfig.texlab.setup({ capabilities = capabilities }) -- LaTeX
      lspconfig.ts_ls.setup({ capabilities = capabilities }) -- ✅ Modern TypeScript LSP
      lspconfig.vuels.setup({ capabilities = capabilities })
      lspconfig.zls.setup({ capabilities = capabilities }) -- Zig
      lspconfig.zk.setup({ capabilities = capabilities }) -- Markdown, Zettelkasten

      -- Keymaps
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
