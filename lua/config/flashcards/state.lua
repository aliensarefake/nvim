-- Review state persistence
-- Reads/writes .state.json for tracking card review history

local M = {}

function M.load(state_path)
  local f = io.open(state_path, "r")
  if not f then return {} end
  local raw = f:read("*a")
  f:close()
  if raw == "" then return {} end
  local ok, data = pcall(vim.json.decode, raw)
  if not ok then
    vim.notify("flashcards: corrupt state file, starting fresh", vim.log.levels.WARN)
    return {}
  end
  return data
end

function M.save(state_path, data)
  local dir = vim.fn.fnamemodify(state_path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  local raw = vim.json.encode(data)
  local f = io.open(state_path, "w")
  if not f then
    vim.notify("flashcards: failed to write state", vim.log.levels.ERROR)
    return
  end
  f:write(raw)
  f:close()
end

function M.get_card(data, card_id)
  return data[card_id]
end

function M.set_card(data, card_id, card_state)
  data[card_id] = card_state
end

-- returns list of {card_id=..., state=...} for cards due today or earlier
function M.get_due_ids(data, today)
  today = today or os.date("%Y-%m-%d")
  local due = {}
  for id, st in pairs(data) do
    if st.next_review and st.next_review <= today then
      table.insert(due, id)
    end
  end
  return due
end

return M
