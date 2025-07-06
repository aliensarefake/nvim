-- UI Enhancement Plugins
-- Statusline, bufferline, notifications, and folding

return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { 
            { "filename", path = 1 }, -- Show relative path
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "lazy", "mason", "oil" },
      })
    end,
  },

  -- Bufferline (tabs)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          themable = true,
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          indicator = {
            icon = "▎",
            style = "icon",
          },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "oil",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin",
          enforce_regular_tabs = false,
          always_show_bufferline = true,
        },
      })
      
      -- Keymaps for buffer navigation
      vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
      vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
      vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
      vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Close unpinned buffers" })
    end,
  },

  -- Better UI for messages, cmdline and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        messages = {
          enabled = true,
          view = "mini",
          view_error = "mini",
          view_warn = "mini",
          view_history = "messages",
          view_search = "virtualtext",
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              find = "written",
            },
            opts = { skip = true },
          },
        },
      })
      
      -- Notify setup
      require("notify").setup({
        background_colour = "#000000",
        render = "minimal",
        stages = "fade",
        timeout = 3000,
        top_down = false,
      })
    end,
  },

  -- Advanced folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      -- Using ufo provider need remap `zR` and `zM`
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
      
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        open_fold_hl_timeout = 150,
        close_fold_kinds = {},
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (" 󰁂 %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end,
      })
    end,
  },
}