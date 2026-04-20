-- SM-2 spaced repetition algorithm
-- Pure logic, no I/O

local M = {}

-- Quality mapping: user rates 1-4, SM-2 uses 0-5
-- 1 (Again) → 1 (fail, reset), 2 (Hard) → 3 (pass, ease drops)
-- 3 (Good) → 4 (pass, ease stable), 4 (Easy) → 5 (pass, ease rises)
local quality_map = { [1] = 1, [2] = 3, [3] = 4, [4] = 5 }

function M.new_card_state()
  return {
    ease = 2.5,
    interval = 0,
    reps = 0,
    next_review = os.date("%Y-%m-%d"),
    last_review = nil,
    lapses = 0,
  }
end

function M.review(card, rating)
  local q = quality_map[rating] or 3
  local new = {
    ease = card.ease,
    interval = card.interval,
    reps = card.reps,
    lapses = card.lapses or 0,
    last_review = os.date("%Y-%m-%d"),
  }

  if q < 3 then
    -- failed: reset
    new.reps = 0
    new.interval = 1
    new.lapses = new.lapses + 1
  else
    if new.reps == 0 then
      new.interval = 1
    elseif new.reps == 1 then
      new.interval = 6
    else
      new.interval = math.ceil(card.interval * card.ease)
    end
    new.reps = new.reps + 1
  end

  -- update ease factor
  new.ease = card.ease + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
  if new.ease < 1.3 then new.ease = 1.3 end

  -- compute next review date
  local t = os.time()
  local next_t = t + new.interval * 86400
  new.next_review = os.date("%Y-%m-%d", next_t)

  return new
end

function M.is_due(card_state, today)
  today = today or os.date("%Y-%m-%d")
  if not card_state or not card_state.next_review then return true end
  return card_state.next_review <= today
end

return M
