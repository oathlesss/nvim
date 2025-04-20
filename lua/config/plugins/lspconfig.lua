return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    config = function()
      local lspconfig = require("lspconfig")

      vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format() end)

      -- Setup lua_ls
      lspconfig.lua_ls.setup {}

      -- Disable inlay hints globally
      vim.lsp.inlay_hint.enable(false)

      -- Setup basedpyright
      lspconfig.basedpyright.setup {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "off",
              -- ignore = { "reportUnreachable" },
              disableOrganizeImports = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      }

      -- Setup djlsp
      lspconfig.djlsp.setup {
        cmd = { "/Users/rubenhesselink/Developer/Projects/Personal/django-template-lsp/env/bin/djlsp" },
        root_dir = lspconfig.util.root_pattern("manage.py", ".git"),
      }

      -- Optional LspAttach autocommand for formatting (uncomment if needed)
      -- vim.api.nvim_create_autocmd("LspAttach", {
      --   callback = function(args)
      --     local client = vim.lsp.get_client_by_id(args.data.client_id)
      --     if not client then return end
      --     if client.supports_method("textDocument/formatting") then
      --       vim.api.nvim_create_autocmd("BufWritePre", {
      --         buffer = args.buf,
      --         callback = function()
      --           vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
      --         end,
      --       })
      --     end
      --   end,
      -- })
    end,
  }
}
