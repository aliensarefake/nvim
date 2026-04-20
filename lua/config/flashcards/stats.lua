-- Analytics computations for flashcard review data

local M = {}

local sm2 = require("config.flashcards.sm2")

-- count cards due today, split into new vs review
function M.due_counts(all_cards, state_data, today)
  today = today or os.date("%Y-%m-%d")
  local new_count, review_count = 0, 0

  for _, card in ipairs(all_cards) do
    local st = state_data[card.id]
    if not st then
      new_count = new_count + 1
    elseif sm2.is_due(st, today) then
      review_count = review_count + 1
    end
  end

  return { new = new_count, review = review_count, total = new_count + review_count }
end

-- consecutive days with at least one review
function M.streak(state_data)
  -- collect all unique review dates
  local dates = {}
  for _, st in pairs(state_data) do
    if st.last_review then
      dates[st.last_review] = true
    end
  end

  if vim.tbl_isempty(dates) then return 0 end

  local streak = 0
  local day = os.time()

  -- allow skipping today (haven't reviewed yet), but not more
  local d = os.date("%Y-%m-%d", day)
  if not dates[d] then
    day = day - 86400
  end

  for _ = 1, 3650 do
    d = os.date("%Y-%m-%d", day)
    if not dates[d] then break end
    streak = streak + 1
    day = day - 86400
  end

  return streak
end

-- retention rate: % of reviews rated Good(3) or Easy(4) in last N days
-- we track this from state — cards with lapses vs total reviews
function M.retention(state_data)
  local total, passed = 0, 0
  for _, st in pairs(state_data) do
    if st.last_review then
      total = total + 1
      if st.reps > 0 then
        passed = passed + 1
      end
    end
  end
  if total == 0 then return 0 end
  return math.floor(passed / total * 100)
end

-- forecast: how many cards due each day for next 7 days
function M.forecast(state_data, days)
  days = days or 7
  local counts = {}
  local t = os.time()

  for i = 0, days - 1 do
    local d = os.date("%Y-%m-%d", t + i * 86400)
    local label = os.date("%a", t + i * 86400)
    local count = 0
    for _, st in pairs(state_data) do
      if st.next_review == d then
        count = count + 1
      end
    end
    table.insert(counts, { date = d, label = label, count = count })
  end

  return counts
end

-- hardest cards: lowest ease factor
function M.hardest(state_data, all_cards, n)
  n = n or 5
  -- build lookup from card list
  local card_lookup = {}
  for _, c in ipairs(all_cards) do
    card_lookup[c.id] = c
  end

  local sorted = {}
  for id, st in pairs(state_data) do
    if card_lookup[id] then
      table.insert(sorted, { id = id, ease = st.ease, card = card_lookup[id] })
    end
  end

  table.sort(sorted, function(a, b) return a.ease < b.ease end)

  local result = {}
  for i = 1, math.min(n, #sorted) do
    table.insert(result, sorted[i])
  end
  return result
end

-- per-deck summary
function M.deck_summary(decks, state_data, today)
  today = today or os.date("%Y-%m-%d")
  local summaries = {}
  for _, deck in ipairs(decks) do
    local due = 0
    for _, card in ipairs(deck.cards) do
      local st = state_data[card.id]
      if not st or sm2.is_due(st, today) then
        due = due + 1
      end
    end
    table.insert(summaries, {
      name = deck.name,
      total = #deck.cards,
      due = due,
    })
  end
  return summaries
end

return M
