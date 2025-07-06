-- LSP Configuration
-- Language Server Protocol support for C, JavaScript, TypeScript, Python, and C++

return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP installer
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      
      -- Additional LSP functionality
      "folke/neodev.nvim",
      
      -- Telescope for LSP navigation
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Setup neodev for Neovim Lua development
      require("neodev").setup()
      
      -- Setup Mason
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      
      -- Ensure LSP servers are installed
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",      -- C/C++
          "tsserver",    -- JavaScript/TypeScript
          "pyright",     -- Python
          "lua_ls",      -- Lua
        },
        automatic_installation = true,
      })
      
      -- LSP settings
      local lspconfig = require("lspconfig")
      
      -- Global mappings
      vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
      
      -- Use LspAttach autocommand to only map after the language server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          
          -- Buffer local mappings
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
          
          -- Additional telescope LSP keymaps
          local telescope_builtin = require("telescope.builtin")
          vim.keymap.set("n", "<leader>gr", function()
            telescope_builtin.lsp_references(require("telescope.themes").get_dropdown({
              previewer = false,
              layout_config = {
                width = 0.8,
                height = 0.4,
              },
            }))
          end, vim.tbl_extend("force", opts, { desc = "Show references" }))
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "<leader>gt", telescope_builtin.lsp_type_definitions, vim.tbl_extend("force", opts, { desc = "Telescope type definitions" }))
          vim.keymap.set("n", "<leader>gi", telescope_builtin.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Telescope implementations" }))
          vim.keymap.set("n", "<leader>gc", telescope_builtin.lsp_incoming_calls, vim.tbl_extend("force", opts, { desc = "Telescope incoming calls" }))
          vim.keymap.set("n", "<leader>go", telescope_builtin.lsp_outgoing_calls, vim.tbl_extend("force", opts, { desc = "Telescope outgoing calls" }))
          vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        end,
      })
      
      -- Border for floating windows
      local border = {
        { "┌", "FloatBorder" },
        { "─", "FloatBorder" },
        { "┐", "FloatBorder" },
        { "│", "FloatBorder" },
        { "┘", "FloatBorder" },
        { "─", "FloatBorder" },
        { "└", "FloatBorder" },
        { "│", "FloatBorder" },
      }
      
      -- LSP handlers
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }
      
      -- Diagnostic config
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        float = {
          border = border,
          source = "always",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
      
      -- Signs
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      
      -- Server configurations
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- C/C++ (clangd)
      lspconfig.clangd.setup({
        capabilities = capabilities,
        handlers = handlers,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      })
      
      -- JavaScript/TypeScript
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        handlers = handlers,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })
      
      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
        handlers = handlers,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            },
          },
        },
      })
      
      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        handlers = handlers,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
            format = {
              enable = false,
            },
          },
        },
      })
    end,
  },
}