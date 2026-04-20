-- LSP Configuration
-- Clean and simple setup for Language Server Protocol support

return {
  -- Mason: LSP installer
  {
    "williamboman/mason.nvim",
    config = function()
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
    end,
  },

  -- Mason-lspconfig: Bridge between Mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",      -- C/C++
          "ts_ls",       -- JavaScript/TypeScript
          "pyright",     -- Python
          "lua_ls",      -- Lua
          "jdtls",       -- Java
          "solidity_ls_nomicfoundation", -- Solidity
        },
        automatic_installation = true,
        automatic_enable = false,
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Setup neodev for Neovim Lua development
      require("neodev").setup()

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }

      -- Global defaults for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
        handlers = handlers,
      })

      vim.lsp.config("clangd", {
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

      vim.lsp.config("pyright", {
        flags = {
          debounce_text_changes = 1500,
        },
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              diagnosticMode = "openFilesOnly",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticSeverityOverrides = {
                reportGeneralTypeIssues = "warning",
                reportOptionalMemberAccess = "none",
                reportOptionalSubscript = "none",
                reportPrivateImportUsage = "none",
              },
            },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            format = { enable = false },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            cargo = {
              targetDir = true,
            },
            procMacro = { enable = true },
            diagnostics = {
              disabled = { "unresolved-proc-macro" },
            },
            files = {
              excludeDirs = { ".git", ".direnv", "node_modules", "target" },
            },
            inlayHints = {
              closingBraceHints = { enable = false },
              lifetimeElisionHints = { enable = "never" },
            },
          },
        },
      })

      vim.lsp.enable({
        "clangd",
        "ts_ls",
        "pyright",
        "lua_ls",
        "jdtls",
        "solidity_ls_nomicfoundation",
        "rust_analyzer",
      })

      -- Global mappings
      vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = false }) end, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = false }) end, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })

      -- Use LspAttach autocommand to only map after the language server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings
          local opts = { buffer = ev.buf }
          local telescope_builtin = require("telescope.builtin")

          local lsp_dropdown = require("config.telescope-layout").lsp_dropdown

          -- gr* pattern for LSP navigation with Telescope
          vim.keymap.set("n", "grD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          vim.keymap.set("n", "grd", function()
            telescope_builtin.lsp_definitions(lsp_dropdown({
              jump_type = "never",
              fname_width = 60,
              show_line = true,
              trim_text = true,
            }))
          end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "grr", function()
            telescope_builtin.lsp_references(lsp_dropdown({
              include_declaration = false,
              include_current_line = false,
              fname_width = 60,
              show_line = true,
              trim_text = true,
            }))
          end, vim.tbl_extend("force", opts, { desc = "Show references" }))
          vim.keymap.set("n", "gri", function()
            telescope_builtin.lsp_implementations(lsp_dropdown({
              jump_type = "never",
              fname_width = 60,
            }))
          end, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "grt", function()
            telescope_builtin.lsp_type_definitions(lsp_dropdown({
              jump_type = "never",
              fname_width = 60,
            }))
          end, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
          vim.keymap.set("n", "grc", function()
            telescope_builtin.lsp_incoming_calls(lsp_dropdown({
              fname_width = 60,
            }))
          end, vim.tbl_extend("force", opts, { desc = "Incoming calls" }))
          vim.keymap.set("n", "gro", function()
            telescope_builtin.lsp_outgoing_calls(lsp_dropdown({
              fname_width = 60,
            }))
          end, vim.tbl_extend("force", opts, { desc = "Outgoing calls" }))

          -- Other LSP keymaps
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        end,
      })

      -- Diagnostic config
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
          spacing = 4,
          update_in_insert = false,
        },
        float = {
          border = border,
          source = "always",
          focusable = false,
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
}