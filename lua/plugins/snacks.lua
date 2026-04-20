-- snacks.nvim - folke's collection of small QoL utilities
-- Only enabling modules that don't conflict with existing setup:
--   - notifier disabled (noice handles messages, nvim-notify handles toasts)
--   - picker disabled (telescope is the picker)
--   - statuscolumn disabled (foldcolumn + signcolumn already configured)

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    words = { enabled = true },
    scroll = { enabled = true },
    zen = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
           ██╗     ██╗███╗   ███╗
           ██║     ██║████╗ ████║
           ██║     ██║██╔████╔██║
           ██║     ██║██║╚██╔╝██║
           ███████╗██║██║ ╚═╝ ██║
           ╚══════╝╚═╝╚═╝     ╚═╝
        ]],
        keys = {
          { icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
          { icon = " ", key = "n", desc = "New file", action = ":enew" },
          { icon = " ", key = "g", desc = "Grep", action = ":Telescope live_grep" },
          { icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
          { icon = " ", key = "j", desc = "Daily note", action = function() vim.cmd("normal \\<Space>j") end },
          { icon = " ", key = "s", desc = "Study flashcards", action = ":Study" },
          { icon = " ", key = "o", desc = "Inbox", action = function() vim.cmd("edit ~/notes/inbox.md") end },
          { icon = " ", key = "L", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
    notifier = { enabled = false },
    picker = { enabled = false },
    statuscolumn = { enabled = false },
  },
  keys = {
    { "<leader>z",  function() Snacks.zen() end, desc = "Zen mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Zoom (zen)" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
  },
}
