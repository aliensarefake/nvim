-- Card creation UI
local float = require("config.flashcards.ui.float")
local card_mod = require("config.flashcards.card")

local M = {}

function M.create_card(cards_dir, initial_answer)
  local buf, win = float.open_float({ title = "New Card", width = 0.6, height = 0.4 })
  vim.bo[buf].buftype = "acwrite"
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = true

  local template
  if initial_answer and initial_answer ~= "" then
    template = { "Write your question here", "%", initial_answer }
  else
    template = { "Write your question here", "%", "Write your answer here" }
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, template)
  pcall(vim.api.nvim_buf_set_name, buf, "flashcard://new-" .. tostring(buf))

  vim.api.nvim_win_set_cursor(win, { 1, 0 })

  local function save_card()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local raw = table.concat(lines, "\n")
    local sep = raw:find("\n%%\n")
    if not sep then
      vim.notify("flashcards: missing %% separator between Q and A", vim.log.levels.ERROR)
      return
    end

    local question = vim.trim(raw:sub(1, sep - 1))
    local answer = vim.trim(raw:sub(sep + 3))
    if question == "" or answer == "" or question == "Write your question here" then
      vim.notify("flashcards: question and answer cannot be empty", vim.log.levels.WARN)
      return
    end

    local function add_to_deck(deck_path, deck_name)
      if card_mod.append_card(deck_path, question, answer) then
        vim.notify("flashcards: card added to " .. deck_name, vim.log.levels.INFO)
        float.close(win)
      end
    end

    local decks = card_mod.list_decks(cards_dir)

    if #decks == 0 then
      local path = card_mod.create_deck(cards_dir, "General", {})
      if path then
        add_to_deck(path, "General")
      end
      return
    end

    if #decks == 1 then
      add_to_deck(decks[1].path, decks[1].name)
      return
    end

    local choices = {}
    for _, d in ipairs(decks) do
      table.insert(choices, d.name)
    end
    table.insert(choices, "+ New deck")

    vim.ui.select(choices, { prompt = "Add to deck:" }, function(choice, i)
      if not choice then return end

      local deck_path
      if choice == "+ New deck" then
        local name = vim.fn.input("Deck name: ")
        if name == "" then return end
        deck_path = card_mod.create_deck(cards_dir, name, {})
        if not deck_path then return end
      else
        deck_path = decks[i].path
      end

      add_to_deck(deck_path, choice)
    end)
  end

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      save_card()
      vim.bo[buf].modified = false
    end,
  })

  vim.keymap.set("n", "<C-s>", save_card, { buffer = buf, silent = true })
  vim.keymap.set("n", "q", function() float.close(win) end, { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", function() float.close(win) end, { buffer = buf, silent = true })
end

return M
