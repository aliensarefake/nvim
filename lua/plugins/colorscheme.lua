-- Colorscheme Plugin Configuration
-- Tokyo Night theme with custom settings

-- For more options:
-- https://github.com/folke/tokyonight.nvim

return {
  "folke/tokyonight.nvim",
  lazy = false,    -- Load immediately
  priority = 1000, -- Load before other plugins
  config = function()
    require("tokyonight").setup({
      style = "night", -- Options: storm, moon, night, day
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "terminal" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = true,
      
      -- Custom highlights
      on_highlights = function(hl, c)
        hl.CursorLineNr = { fg = c.orange, bold = true }
        hl.LineNr = { fg = c.comment }
        hl.DiagnosticVirtualTextError = { bg = c.none, fg = c.error }
        hl.DiagnosticVirtualTextWarn = { bg = c.none, fg = c.warning }
        hl.DiagnosticVirtualTextInfo = { bg = c.none, fg = c.info }
        hl.DiagnosticVirtualTextHint = { bg = c.none, fg = c.hint }
      end,
    })
    
    -- Apply colorscheme
    vim.cmd.colorscheme("tokyonight")
  end,
}