-- Lazy.nvim Plugin Manager Configuration
-- This file sets up the plugin manager and loads all plugin specifications

-- For more configuration options, see:
-- https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration

require("lazy").setup("plugins", {
  -- Enable luarocks support for plugins that need it
  rocks = {
    enabled = true,
    hererocks = true, -- Use hererocks to auto-install luarocks if needed
  },

  -- Automatically install missing plugins on startup
  install = {
    missing = true,
    colorscheme = { "tokyonight" },
  },

  -- Automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,
  },

  -- Lazy-loading performance optimizations
  performance = {
    rtp = {
      -- Disable some built-in plugins for better startup time
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  -- UI customization
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚡",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
    },
  },
})
