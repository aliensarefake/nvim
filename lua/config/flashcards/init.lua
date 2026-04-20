-- Flashcard SRS plugin
-- Spaced repetition study system built into Neovim

local M = {}

local defaults = {
  cards_dir = vim.fn.expand("~/notes/flashcards"),
}

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", defaults, opts or {})
  local dir = opts.cards_dir

  -- ensure cards directory exists
  vim.fn.mkdir(dir, "p")

  local ui = require("config.flashcards.ui")

  -- commands
  vim.api.nvim_create_user_command("Study", function() ui.study(dir) end, { desc = "Study due flashcards" })
  vim.api.nvim_create_user_command("StudyDeck", function() ui.study_deck(dir) end, { desc = "Study a specific deck" })
  vim.api.nvim_create_user_command("CardNew", function() ui.create_card(dir) end, { desc = "Create a new flashcard" })
  vim.api.nvim_create_user_command("FlashcardStats", function() ui.dashboard(dir) end, { desc = "Flashcard dashboard" })
  vim.api.nvim_create_user_command("FlashcardBrowse", function() ui.browse(dir) end, { desc = "Browse flashcards" })
  vim.api.nvim_create_user_command("FlashcardDecks", function() ui.list_decks(dir) end, { desc = "List flashcard decks" })

  -- keybindings (<leader>a namespace)
  vim.keymap.set("n", "<leader>as", function() ui.study(dir) end, { desc = "Study due cards" })
  vim.keymap.set("n", "<leader>aS", function() ui.study_deck(dir) end, { desc = "Study specific deck" })
  vim.keymap.set("n", "<leader>ac", function() ui.create_card(dir) end, { desc = "Create flashcard" })
  vim.keymap.set("v", "<leader>ac", function()
    -- grab visual selection as initial answer
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.visualmode() })
    local text = table.concat(lines, "\n")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    vim.schedule(function() ui.create_card(dir, text) end)
  end, { desc = "Create flashcard from selection" })
  vim.keymap.set("n", "<leader>ad", function() ui.dashboard(dir) end, { desc = "Flashcard stats" })
  vim.keymap.set("n", "<leader>ab", function() ui.browse(dir) end, { desc = "Browse flashcards" })
  vim.keymap.set("n", "<leader>al", function() ui.list_decks(dir) end, { desc = "List decks" })
  vim.keymap.set("n", "<leader>ae", function()
    vim.cmd.edit(dir)
  end, { desc = "Edit flashcard decks" })
end

return M
