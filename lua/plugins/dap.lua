-- Debug Adapter Protocol (DAP) Configuration
-- Turns Neovim into a full-fledged debugger with UI

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      keys = {
        {
          "<leader>du",
          function()
            require("dapui").toggle({})
          end,
          desc = "Dap UI",
        },
        {
          "<leader>de",
          function()
            require("dapui").eval()
          end,
          desc = "Eval",
          mode = { "n", "v" },
        },
      },
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        
        dapui.setup(opts)

        -- Automatically open/close the UI when debugging starts/ends
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },
    
    -- Virtual text for the debugger (shows values inline)
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },

    -- Mason integration to auto-install debug adapters
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "williamboman/mason.nvim" },
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        automatic_installation = false,
        handlers = {},
        ensure_installed = {
          "debugpy", -- Python
          "codelldb", -- Rust/C/C++
        },
      },
    },

    -- Python specific configuration
    {
      "mfussenegger/nvim-dap-python",
      ft = "python",
      dependencies = {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
      },
      config = function()
        local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        require("dap-python").setup(path)
      end,
    },
  },
  
  -- Keymaps
  keys = {
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Continue",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Set Breakpoint with Condition",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.open()
      end,
      desc = "Debug: Open REPL",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debug: Run Last",
    },
  },

  config = function()
    local dap = require("dap")
    
    -- Rust / C / C++ configuration via codelldb
    if not dap.adapters.codelldb then
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }
    end

    dap.configurations.rust = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    -- Aesthetic: Use nicer icons for breakpoints
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    local icons = {
      Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = { " ", "DiagnosticInfo" },
      BreakpointCondition = { " ", "DiagnosticInfo" },
      BreakpointRejected  = { " ", "DiagnosticError" },
      LogPoint            = { ".>", "DiagnosticInfo" },
    }
    
    for name, sign in pairs(icons) do
      vim.fn.sign_define("Dap" .. name, { 
        text = sign[1], 
        texthl = sign[2], 
        linehl = sign[3], 
        numhl = sign[3] 
      })
    end
  end,
}