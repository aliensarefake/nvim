-- Stats dashboard
local float = require("config.flashcards.ui.float")
local card_mod = require("config.flashcards.card")
local state_mod = require("config.flashcards.state")
local stats_mod = require("config.flashcards.stats")

local M = {}

function M.dashboard(cards_dir)
  local state_path = cards_dir .. "/.state.json"
  local state_data = state_mod.load(state_path)
  local decks = card_mod.list_decks(cards_dir)
  local today = os.date("%Y-%m-%d")

  local all_cards = {}
  for _, deck in ipairs(decks) do
    for _, c in ipairs(deck.cards) do
      table.insert(all_cards, c)
    end
  end

  local due = stats_mod.due_counts(all_cards, state_data, today)
  local streak = stats_mod.streak(state_data)
  local retention = stats_mod.retention(state_data)
  local forecast = stats_mod.forecast(state_data, 7)
  local hardest = stats_mod.hardest(state_data, all_cards, 5)
  local deck_sums = stats_mod.deck_summary(decks, state_data, today)

  local lines = {
    "",
    "# Flashcard Stats",
    "",
    string.format("**Due today:** %d cards (%d new, %d review)", due.total, due.new, due.review),
    string.format("**Streak:** %d day%s", streak, streak == 1 and "" or "s"),
    string.format("**Total:** %d cards across %d decks", #all_cards, #decks),
    "",
    string.format("**Retention:** %d%%", retention),
    "",
    "## Forecast (next 7 days)",
    "",
  }

  local forecast_parts = {}
  for _, f in ipairs(forecast) do
    table.insert(forecast_parts, string.format("%s: %d", f.label, f.count))
  end
  table.insert(lines, table.concat(forecast_parts, " | "))
  table.insert(lines, "")

  if #hardest > 0 then
    table.insert(lines, "## Hardest cards")
    table.insert(lines, "")
    for i, h in ipairs(hardest) do
      local q = h.card.question:sub(1, 40)
      if #h.card.question > 40 then q = q .. "..." end
      table.insert(lines, string.format("%d. %s (%.2f)", i, q, h.ease))
    end
    table.insert(lines, "")
  end

  if #deck_sums > 0 then
    table.insert(lines, "## Decks")
    table.insert(lines, "")
    for _, d in ipairs(deck_sums) do
      table.insert(lines, string.format("- **%s** — %d cards, %d due", d.name, d.total, d.due))
    end
    table.insert(lines, "")
  end

  local buf, win = float.open_float({ title = "Flashcard Stats", width = 0.65, height = 0.7 })
  vim.bo[buf].filetype = "markdown"
  float.set_buf_lines(buf, lines)
  float.bind_close(buf, win)
end

return M
