-- Render Markdown Plugin
-- Enhanced markdown rendering with concealment

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({
      -- General configuration
      enabled = true,
      max_file_size = 10.0, -- MB
      debounce = 100, -- ms
      render_modes = { "n", "v", "i", "c" },
      anti_conceal = {
        enabled = true,
      },
      
      -- Heading configuration
      heading = {
        enabled = true,
        sign = true,
        position = "overlay",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        signs = { "󰫎 " },
        width = "full",
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_prefix = false,
        above = "▄",
        below = "▀",
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
      
      -- Code block configuration
      code = {
        enabled = true,
        sign = true,
        style = "full",
        position = "left",
        language_pad = 0,
        disable_background = { "diff" },
        width = "full",
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = "thin",
        above = "▄",
        below = "▀",
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
      },
      
      -- Dash configuration
      dash = {
        enabled = true,
        icon = "─",
        width = "full",
        highlight = "RenderMarkdownDash",
      },
      
      -- Bullet configuration
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
        left_pad = 0,
        right_pad = 0,
        highlight = "RenderMarkdownBullet",
      },
      
      -- Checkbox configuration
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
        },
        checked = {
          icon = "󰱒 ",
          highlight = "RenderMarkdownChecked",
        },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
          important = { raw = "[!]", rendered = "󰅾 ", highlight = "RenderMarkdownImportant" },
        },
      },
      
      -- Quote configuration
      quote = {
        enabled = true,
        icon = "▌",
        repeat_linebreak = false,
        highlight = "RenderMarkdownQuote",
      },
      
      -- Pipe table configuration
      pipe_table = {
        enabled = true,
        preset = "none",
        style = "full",
        cell = "padded",
        min_width = 0,
        border = {
          "│", "─", "│", "│",
          "╭", "╮", "╯", "╰",
          "├", "┤", "┬", "┴",
          "┼",
        },
        alignment_indicator = "─",
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
        filler = "RenderMarkdownTableFill",
      },
      
      -- Callout configuration
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      },
      
      -- Link configuration
      link = {
        enabled = true,
        image = "󰥶 ",
        email = "󰊫 ",
        hyperlink = "󰌹 ",
        highlight = "RenderMarkdownLink",
        custom = {
          web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
        },
      },
      
      -- Sign configuration
      sign = {
        enabled = true,
        highlight = "RenderMarkdownSign",
      },
    })
    
    -- Custom highlight groups
    vim.cmd [[
      highlight RenderMarkdownH1Bg guibg=#1e2718
      highlight RenderMarkdownH2Bg guibg=#21262d
      highlight RenderMarkdownH3Bg guibg=#30363d
      highlight RenderMarkdownH4Bg guibg=#484f58
      highlight RenderMarkdownH5Bg guibg=#484f58
      highlight RenderMarkdownH6Bg guibg=#484f58
      
      highlight RenderMarkdownH1 guifg=#c9d1d9 gui=bold
      highlight RenderMarkdownH2 guifg=#c9d1d9 gui=bold
      highlight RenderMarkdownH3 guifg=#c9d1d9 gui=bold
      highlight RenderMarkdownH4 guifg=#c9d1d9
      highlight RenderMarkdownH5 guifg=#c9d1d9
      highlight RenderMarkdownH6 guifg=#c9d1d9
      
      highlight RenderMarkdownCode guibg=#1c1c1c
      highlight RenderMarkdownCodeInline guibg=#2d2d2d
      highlight RenderMarkdownBullet guifg=#89ddff
      highlight RenderMarkdownQuote guifg=#484f58
      highlight RenderMarkdownDash guifg=#484f58
      
      highlight RenderMarkdownChecked guifg=#89ddff
      highlight RenderMarkdownUnchecked guifg=#f78c6c
      highlight RenderMarkdownTodo guifg=#ffcb6b
      highlight RenderMarkdownImportant guifg=#ff5370
      
      highlight RenderMarkdownTableHead guifg=#c792ea gui=bold
      highlight RenderMarkdownTableRow guifg=#c9d1d9
      highlight RenderMarkdownTableFill guifg=#484f58
      
      highlight RenderMarkdownInfo guifg=#89ddff
      highlight RenderMarkdownSuccess guifg=#c3e88d
      highlight RenderMarkdownHint guifg=#82aaff
      highlight RenderMarkdownWarn guifg=#ffcb6b
      highlight RenderMarkdownError guifg=#ff5370
      
      highlight RenderMarkdownLink guifg=#c792ea gui=underline
      highlight RenderMarkdownSign guifg=#484f58
    ]]
  end,
}