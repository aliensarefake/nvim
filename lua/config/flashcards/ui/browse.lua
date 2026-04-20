-- Browse and list decks
local card_mod = require("config.flashcards.card")
local sm2 = require("config.flashcards.sm2")
local state_mod = require("config.flashcards.state")

local M = {}

function M.browse(cards_dir)
  local has_telescope, pickers = pcall(require, "telescope.pickers")
  if not has_telescope then
    require("config.flashcards.ui.study").study_deck(cards_dir)
    return
  end

  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previewers = require("telescope.previewers")

  local decks = card_mod.list_decks(cards_dir)
  local entries = {}
  for _, deck in ipairs(decks) do
    for _, c in ipairs(deck.cards) do
      table.insert(entries, {
        display = string.format("[%s] %s", deck.name, c.question:sub(1, 60)),
        question = c.question,
        answer = c.answer,
        deck = deck.name,
        deck_path = deck.path,
      })
    end
  end

  pickers.new({}, {
    prompt_title = "Flashcards",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.display,
        }
      end,
    }),
    previewer = previewers.new_buffer_previewer({
      title = "Card Preview",
      define_preview = function(self, entry)
        local lines = {
          "# " .. entry.value.deck,
          "",
          "## Question",
          "",
        }
        for _, l in ipairs(vim.split(entry.value.question, "\n")) do
          table.insert(lines, l)
        end
        table.insert(lines, "")
        table.insert(lines, "## Answer")
        table.insert(lines, "")
        for _, l in ipairs(vim.split(entry.value.answer, "\n")) do
          table.insert(lines, l)
        end
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        vim.bo[self.state.bufnr].filetype = "markdown"
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry then
          vim.cmd.edit(entry.value.deck_path)
        end
      end)
      return true
    end,
  }):find()
end

function M.list_decks(cards_dir)
  local decks = card_mod.list_decks(cards_dir)
  if #decks == 0 then
    vim.notify("flashcards: no decks found", vim.log.levels.INFO)
    return
  end

  local state_path = cards_dir .. "/.state.json"
  local state_data = state_mod.load(state_path)
  local today = os.date("%Y-%m-%d")

  local items = {}
  for _, deck in ipairs(decks) do
    local due = 0
    for _, c in ipairs(deck.cards) do
      local st = state_data[c.id]
      if not st or sm2.is_due(st, today) then
        due = due + 1
      end
    end
    table.insert(items, string.format("%s — %d cards, %d due", deck.name, #deck.cards, due))
  end

  vim.ui.select(items, { prompt = "Decks (select to edit):" }, function(_, i)
    if not i then return end
    vim.cmd.edit(decks[i].path)
  end)
end

return M
