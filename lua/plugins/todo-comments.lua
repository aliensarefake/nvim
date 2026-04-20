-- TODO/NOTE/FIX highlighting + navigation + search
-- Replaces the custom regex-based TODO system that used to live in utils.lua

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TodoTrouble", "TodoTelescope", "TodoQuickFix", "TodoLocList" },
  config = function()
    require("todo-comments").setup({
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "ISSUE", "CARELESS" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        IMPORTANT = { icon = " ", color = "warning" },
        MISTAKE = { icon = " ", color = "error" },
      },
      highlight = {
        multiline = false,
        keyword = "bg",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = false, -- match in markdown prose too
      },
      search = {
        pattern = [[\b(KEYWORDS):]],
      },
    })

    vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
    vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous TODO" })
    vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "List TODOs (project)" })
    vim.keymap.set("n", "<leader>fT", "<cmd>TodoQuickFix<cr>", { desc = "TODOs to quickfix" })
  end,
}
