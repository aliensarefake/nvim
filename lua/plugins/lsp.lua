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

      -- LSP settings
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

      -- LSP handlers with borders
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }

      -- Setup servers with mason-lspconfig
      require("mason-lspconfig").setup_handlers({
        -- Default handler for all servers
        function(server_name)
          -- Skip ruff to avoid conflicts with pyright
          if server_name == "ruff" or server_name == "ruff_lsp" then
            return
          end

          lspconfig[server_name].setup({
            capabilities = capabilities,
            handlers = handlers,
          })
        end,

        -- Custom configurations for specific servers
        ["pyright"] = function()
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
        end,

        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            handlers = handlers,
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
        end,

        ["clangd"] = function()
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
        end,

        ["ts_ls"] = function()
          lspconfig.ts_ls.setup({
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
        end,

        ["jdtls"] = function()
          lspconfig.jdtls.setup({
            capabilities = capabilities,
            handlers = handlers,
            cmd = { "jdtls" },
            root_dir = function(fname)
              return lspconfig.util.root_pattern("pom.xml", "gradle.build", ".git", "mvnw", "gradlew")(fname) or vim.fn.getcwd()
            end,
            settings = {
              java = {
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" },
                completion = {
                  favoriteStaticMembers = {
                    "org.junit.jupiter.api.Assertions.*",
                    "org.junit.Assert.*",
                    "org.mockito.Mockito.*",
                  },
                },
                sources = {
                  organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                  },
                },
                codeGeneration = {
                  toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                  },
                },
              },
            },
          })
        end,

        ["solidity_ls_nomicfoundation"] = function()
          lspconfig.solidity_ls_nomicfoundation.setup({
            capabilities = capabilities,
            handlers = handlers,
            cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
            filetypes = { "solidity" },
            root_dir = lspconfig.util.root_pattern("hardhat.config.js", "hardhat.config.ts", "foundry.toml", "truffle.js", "truffle-config.js", "package.json", ".git"),
            single_file_support = true,
          })
        end,
      })

      -- Global mappings
      vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
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

          -- Helper to create filtered telescope with horizontal layout (files left, preview right)
          local function lsp_dropdown(opts_override)
            return vim.tbl_deep_extend("force", {
              layout_strategy = "horizontal",
              layout_config = {
                horizontal = {
                  preview_width = 0.65,  -- Preview takes 65% of width
                  results_width = 0.35,  -- File list takes 35% of width
                  width = 0.95,          -- Use 95% of screen width
                  height = 0.85,         -- Use 85% of screen height
                  preview_cutoff = 0,    -- Always show preview
                },
              },
              sorting_strategy = "ascending",  -- Results at top
              initial_mode = "normal",
              prompt_prefix = " ",
              selection_caret = "> ",
              -- Border characters for better visibility
              borderchars = {
                "─", "│", "─", "│", "╭", "╮", "╯", "╰",
              },
            }, opts_override or {})
          end

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