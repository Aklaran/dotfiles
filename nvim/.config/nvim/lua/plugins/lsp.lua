return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Autocomplete
      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
      })

      -- TypeScript LSP (use native API on 0.11+, lspconfig on 0.10)
      if vim.lsp.config and type(vim.lsp.config) == "function" or (vim.fn.has("nvim-0.11") == 1) then
        vim.lsp.config("ts_ls", {
          cmd = { "typescript-language-server", "--stdio" },
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          root_markers = { "pnpm-workspace.yaml", "tsconfig.json", "package.json" },
          capabilities = capabilities,
        })
        vim.lsp.enable("ts_ls")
      else
        require("lspconfig").ts_ls.setup({
          capabilities = capabilities,
          root_dir = require("lspconfig.util").root_pattern("pnpm-workspace.yaml", "package.json", "tsconfig.json"),
        })
      end

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local opts = { buffer = buf }

          -- Clear 0.11 defaults that conflict with our bindings
          pcall(vim.keymap.del, "n", "grn", { buffer = buf })
          pcall(vim.keymap.del, "n", "gra", { buffer = buf })
          pcall(vim.keymap.del, "n", "grr", { buffer = buf })
          pcall(vim.keymap.del, "n", "gri", { buffer = buf })

          -- Navigation
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buf, desc = "Go to declaration" })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "Find references" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buf, desc = "Go to implementation" })
          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = buf, desc = "Go to type definition" })

          -- Info & actions
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover docs" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename symbol" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })

          -- Diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = buf, desc = "Prev diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = buf, desc = "Next diagnostic" })
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = buf, desc = "Show diagnostic" })
        end,
      })
    end,
  },
}
