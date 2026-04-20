-- Card and deck I/O
-- Parses deck files, creates cards, manages deck listing

local M = {}

local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

-- stable card ID from deck name + question text
function M.card_id(deck_name, question)
  return vim.fn.sha256(deck_name .. ":" .. question):sub(1, 8)
end

-- parse YAML frontmatter (basic: key: value and key: [a, b])
local function parse_frontmatter(lines)
  local meta = {}
  for _, line in ipairs(lines) do
    local key, val = line:match("^(%w+):%s*(.+)$")
    if key and val then
      -- check for array syntax [a, b, c]
      local arr = val:match("^%[(.*)%]$")
      if arr then
        local items = {}
        for item in arr:gmatch("[^,]+") do
          table.insert(items, trim(item))
        end
        meta[key] = items
      else
        meta[key] = trim(val)
      end
    end
  end
  return meta
end

-- parse a deck file into {meta={...}, cards={{id, question, answer}, ...}}
function M.parse_deck(filepath)
  local f = io.open(filepath, "r")
  if not f then return nil end
  local raw = f:read("*a")
  f:close()

  local meta = {}
  local body = raw

  -- extract frontmatter
  local fm_start, fm_end = raw:find("^%-%-%-\n(.-)\n%-%-%-")
  if fm_start then
    local fm_text = raw:match("^%-%-%-\n(.-)\n%-%-%-")
    meta = parse_frontmatter(vim.split(fm_text, "\n"))
    body = raw:sub(fm_end + 2) -- skip past closing ---\n
  end

  local deck_name = meta.deck or vim.fn.fnamemodify(filepath, ":t:r")

  -- split body on horizontal rules (--- on its own line)
  local cards = {}
  local blocks = vim.split(body, "\n%-%-%-\n")

  for _, block in ipairs(blocks) do
    block = trim(block)
    if block ~= "" then
      -- split on % separator
      local sep = block:find("\n%%\n")
      if sep then
        local question = trim(block:sub(1, sep - 1))
        local answer = trim(block:sub(sep + 3))
        if question ~= "" and answer ~= "" then
          table.insert(cards, {
            id = M.card_id(deck_name, question),
            question = question,
            answer = answer,
          })
        end
      end
    end
  end

  return { meta = meta, cards = cards, name = deck_name, path = filepath }
end

-- list all .md deck files in the flashcards directory
function M.list_decks(cards_dir)
  local files = vim.fn.glob(cards_dir .. "/*.md", false, true)
  local decks = {}
  for _, fpath in ipairs(files) do
    local deck = M.parse_deck(fpath)
    if deck then
      table.insert(decks, deck)
    end
  end
  return decks
end

-- append a card to a deck file
function M.append_card(deck_path, question, answer)
  local f = io.open(deck_path, "r")
  local existing = ""
  if f then
    existing = f:read("*a")
    f:close()
  end

  -- ensure trailing newline
  if existing ~= "" and not existing:match("\n$") then
    existing = existing .. "\n"
  end

  -- add separator if there are already cards
  local card_text
  if existing:match("%%") then
    -- deck already has cards, add separator
    card_text = string.format("\n---\n\n%s\n%%\n%s\n", question, answer)
  else
    -- first card in deck (or after frontmatter)
    card_text = string.format("\n%s\n%%\n%s\n", question, answer)
  end

  f = io.open(deck_path, "a")
  if not f then
    vim.notify("flashcards: failed to write to " .. deck_path, vim.log.levels.ERROR)
    return false
  end
  f:write(card_text)
  f:close()
  return true
end

-- create a new deck file with frontmatter
function M.create_deck(cards_dir, name, tags)
  local filename = name:lower():gsub("%s+", "-"):gsub("[^%w%-]", "") .. ".md"
  local filepath = cards_dir .. "/" .. filename

  if vim.fn.filereadable(filepath) == 1 then
    vim.notify("flashcards: deck already exists: " .. filename, vim.log.levels.WARN)
    return filepath
  end

  vim.fn.mkdir(cards_dir, "p")
  local f = io.open(filepath, "w")
  if not f then
    vim.notify("flashcards: failed to create deck", vim.log.levels.ERROR)
    return nil
  end

  local tag_str = "[]"
  if tags and #tags > 0 then
    tag_str = "[" .. table.concat(tags, ", ") .. "]"
  end

  f:write(string.format("---\ndeck: %s\ntags: %s\ncreated: %s\n---\n", name, tag_str, os.date("%Y-%m-%d")))
  f:close()
  return filepath
end

return M
