-- Study session runner
local float = require("config.flashcards.ui.float")
local card_mod = require("config.flashcards.card")
local sm2 = require("config.flashcards.sm2")
local state_mod = require("config.flashcards.state")

local M = {}

function M.study(cards_dir, opts)
  opts = opts or {}
  local state_path = cards_dir .. "/.state.json"
  local state_data = state_mod.load(state_path)
  local today = os.date("%Y-%m-%d")

  local decks
  if opts.deck_path then
    local deck = card_mod.parse_deck(opts.deck_path)
    decks = deck and { deck } or {}
  else
    decks = card_mod.list_decks(cards_dir)
  end

  local due = {}
  for _, deck in ipairs(decks) do
    for _, c in ipairs(deck.cards) do
      local st = state_data[c.id]
      if not st or sm2.is_due(st, today) then
        table.insert(due, { card = c, deck = deck.name })
      end
    end
  end

  if #due == 0 then
    vim.notify("flashcards: no cards due for review", vim.log.levels.INFO)
    return
  end

  for i = #due, 2, -1 do
    local j = math.random(i)
    due[i], due[j] = due[j], due[i]
  end

  local idx = 1
  local phase = "question"
  local results = { again = 0, hard = 0, good = 0, easy = 0 }

  local title = string.format("%s [%d/%d]", due[idx].deck, idx, #due)
  local buf, win = float.open_float({ title = title, width = 0.7, height = 0.6 })
  vim.bo[buf].filetype = "markdown"

  local function update_title()
    if not vim.api.nvim_win_is_valid(win) then return end
    local t = string.format("%s [%d/%d]", due[idx].deck, idx, #due)
    vim.api.nvim_win_set_config(win, { title = " " .. t .. " ", title_pos = "center" })
  end

  local function show_question()
    phase = "question"
    update_title()
    local lines = { "" }
    for _, l in ipairs(vim.split(due[idx].card.question, "\n")) do
      table.insert(lines, l)
    end
    table.insert(lines, "")
    table.insert(lines, "")
    table.insert(lines, "               `<Space>` to reveal")
    table.insert(lines, "")
    float.set_buf_lines(buf, lines)
  end

  local function show_answer()
    phase = "answer"
    local lines = { "" }
    for _, l in ipairs(vim.split(due[idx].card.question, "\n")) do
      table.insert(lines, l)
    end
    table.insert(lines, "")
    table.insert(lines, "---")
    table.insert(lines, "")
    for _, l in ipairs(vim.split(due[idx].card.answer, "\n")) do
      table.insert(lines, l)
    end
    table.insert(lines, "")
    table.insert(lines, "")
    table.insert(lines, "  `1` Again  `2` Hard  `3` Good  `4` Easy")
    table.insert(lines, "")
    float.set_buf_lines(buf, lines)
  end

  local function show_complete()
    phase = "complete"
    local total = results.again + results.hard + results.good + results.easy
    local lines = {
      "",
      "# Session Complete",
      "",
      string.format("**Reviewed:** %d cards", total),
      string.format("Again: %d | Hard: %d | Good: %d | Easy: %d",
        results.again, results.hard, results.good, results.easy),
      "",
      "Press any key to close",
      "",
    }
    float.set_buf_lines(buf, lines)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_config(win, { title = " Session Complete ", title_pos = "center" })
    end
    vim.keymap.set("n", "<Space>", function() float.close(win) end, { buffer = buf, silent = true, nowait = true })
    for i = 1, 4 do
      vim.keymap.set("n", tostring(i), function() float.close(win) end, { buffer = buf, silent = true, nowait = true })
    end
  end

  local function rate(rating)
    if phase ~= "answer" then return end
    local c = due[idx]
    local st = state_data[c.card.id] or sm2.new_card_state()
    st = sm2.review(st, rating)
    state_mod.set_card(state_data, c.card.id, st)
    state_mod.save(state_path, state_data)

    local names = { "again", "hard", "good", "easy" }
    results[names[rating]] = results[names[rating]] + 1

    idx = idx + 1
    if idx > #due then
      show_complete()
    else
      show_question()
    end
  end

  local kopts = { buffer = buf, silent = true, nowait = true }
  vim.keymap.set("n", "<Space>", function()
    if phase == "question" then show_answer() end
  end, kopts)
  vim.keymap.set("n", "1", function() rate(1) end, kopts)
  vim.keymap.set("n", "2", function() rate(2) end, kopts)
  vim.keymap.set("n", "3", function() rate(3) end, kopts)
  vim.keymap.set("n", "4", function() rate(4) end, kopts)
  vim.keymap.set("n", "q", function()
    state_mod.save(state_path, state_data)
    float.close(win)
  end, kopts)
  vim.keymap.set("n", "<Esc>", function()
    state_mod.save(state_path, state_data)
    float.close(win)
  end, kopts)

  show_question()
end

function M.study_deck(cards_dir)
  local decks = card_mod.list_decks(cards_dir)
  if #decks == 0 then
    vim.notify("flashcards: no decks found in " .. cards_dir, vim.log.levels.WARN)
    return
  end

  local names = {}
  for _, d in ipairs(decks) do
    table.insert(names, string.format("%s (%d cards)", d.name, #d.cards))
  end

  vim.ui.select(names, { prompt = "Study deck:" }, function(_, i)
    if not i then return end
    M.study(cards_dir, { deck_path = decks[i].path })
  end)
end

return M
