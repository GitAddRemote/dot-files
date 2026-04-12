-- lua/plugins/lsp-config.lua
return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason <-> LSPConfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        -- JS/TS
        "vtsls",
        -- Java (JDT)
        "jdtls",
        -- Rest of your stack
        "bashls",
        "cssls",
        "html",
        "jsonls",
        "gopls",
        "graphql",
        "svelte",
        "terraformls",
        "docker_compose_language_service",
        "gradle_ls",
        "helm_ls",
        "kotlin_language_server",
        "lemminx",      -- XML
        -- "r_language_server", -- uncomment if you actually use R (see note below)
        -- "spectral",         -- uncomment if you want OpenAPI linting (needs Node)
        "sqls",
        "taplo",        -- TOML
        "texlab",       -- LaTeX
        -- "vuels",       -- Vetur (Vue 2). Prefer "volar" for Vue 3.
        "zls",          -- Zig
      },
      automatic_installation = true,
    },
  },

  -- TypeScript: vtsls goodies
  { "yioneko/nvim-vtsls", dependencies = { "neovim/nvim-lspconfig" } },

  -- Java: nvim-jdtls (loads only for Java files; runtime logic is in ftplugin/java.lua)
  { "mfussenegger/nvim-jdtls", ft = { "java" } },

  -- Core LSP servers
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Stop ts_ls if anything tries to start it (we use vtsls)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if c and c.name == "ts_ls" then
            vim.schedule(function() c.stop(true) end)
          end
        end,
      })

      -- Common on_attach
      local function on_attach(_, bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>gd", vim.lsp.buf.definition, "Go to definition")
        map("<leader>gr", vim.lsp.buf.references, "References")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      end

      --------------------------------------------------------------------------
      -- TypeScript / JavaScript via vtsls
      --------------------------------------------------------------------------
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false -- let Prettier/Conform format
          on_attach(client, bufnr)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("<leader>oi", function()
            vim.lsp.buf.execute_command({ command = "typescript.organizeImports" })
          end, "Organize imports")
          map("<leader>fa", function()
            vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll.ts", "source.fixAll" } } })
          end, "Fix all")
        end,
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            preferGoToSourceDefinition = true,
            suggest = { includeCompletionsForModuleExports = true },
            inlayHints = {
              parameterNames           = { enabled = "literals" },
              variableTypes            = { enabled = true },
              functionLikeReturnTypes  = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
            },
            preferences = {
              includePackageJsonAutoImports = "on",
              useLabelDetailsInCompletionEntries = true,
              renameShorthandProperties = true,
            },
          },
          javascript = {
            inlayHints = {
              parameterNames           = { enabled = "literals" },
              variableTypes            = { enabled = true },
              functionLikeReturnTypes  = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
            },
          },
        },
      })

      --------------------------------------------------------------------------
      -- The rest of your servers
      --------------------------------------------------------------------------
      lspconfig.bashls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.gopls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.graphql.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.svelte.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.terraformls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.gradle_ls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.helm_ls.setup({ capabilities = capabilities, on_attach = on_attach })

      -- REMOVE: lspconfig.java_language_server.setup(...)  -- jdtls handles Java via ftplugin/java.lua

      lspconfig.kotlin_language_server.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.lemminx.setup({ capabilities = capabilities, on_attach = on_attach })

      -- R (only if installed)
      if vim.fn.executable("R") == 1 then
        lspconfig.r_language_server.setup({ capabilities = capabilities, on_attach = on_attach })
      end

      -- Spectral (only if installed)
      if vim.fn.executable("spectral-language-server") == 1 then
        lspconfig.spectral.setup({ capabilities = capabilities, on_attach = on_attach })
      end

      lspconfig.sqls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.taplo.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.texlab.setup({ capabilities = capabilities, on_attach = on_attach })

      -- Vue: prefer volar for Vue 3; keep vuels if you truly need Vetur
      -- lspconfig.volar.setup({ capabilities = capabilities, on_attach = on_attach })
      -- lspconfig.vuels.setup({ capabilities = capabilities, on_attach = on_attach })

      lspconfig.zls.setup({ capabilities = capabilities, on_attach = on_attach })
    end,
  },
}
