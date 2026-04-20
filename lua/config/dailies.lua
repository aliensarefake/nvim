-- Daily tasks popup
-- Toggle today's daily note in a floating window

local M = {}

local state = { buf = nil, win = nil }
local dailies_dir = vim.fn.expand("~/notes/tasks/dailies")
local augroup = vim.api.nvim_create_augroup("DailiesFloat", { clear = true })

local function today_path()
  return string.format("%s/%s/%s.md", dailies_dir, os.date("%Y"), os.date("%d-%m"))
end

local function ensure_file(path)
  if vim.fn.filereadable(path) == 1 then return end
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile({
    "---",
    string.format('id: "%s"', os.date("%d-%m")),
    "aliases: []",
    "tags: []",
    "---",
    "",
  }, path)
end

local function save_float_buf()
  if not (state.win and vim.api.nvim_win_is_valid(state.win)) then return end
  local buf = vim.api.nvim_win_get_buf(state.win)
  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
    vim.api.nvim_buf_call(buf, function() vim.cmd("silent write") end)
  end
end

local function close()
  if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
    state.win = nil
    return
  end
  save_float_buf()
  vim.api.nvim_win_close(state.win, true)
  state.win = nil
  -- wipe all float-related autocmds; keymaps left on buffers become no-ops
  vim.api.nvim_create_augroup("DailiesFloat", { clear = true })
end

local function set_close_keymaps(buf)
  local kopts = { buffer = buf, silent = true }
  vim.keymap.set("n", "q", close, kopts)
  vim.keymap.set("n", "<Esc>", close, kopts)
end

local function toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close()
    return
  end

  local path = today_path()
  ensure_file(path)

  -- reuse buffer if it's still valid and points to today's file
  local reuse = state.buf
    and vim.api.nvim_buf_is_valid(state.buf)
    and vim.api.nvim_buf_get_name(state.buf) == vim.fn.fnamemodify(path, ":p")

  if not reuse then
    state.buf = vim.fn.bufadd(path)
    vim.fn.bufload(state.buf)
    vim.bo[state.buf].buflisted = false
  end

  local w = math.floor(vim.o.columns * 0.8)
  local h = math.floor(vim.o.lines * 0.8)

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = w,
    height = h,
    row = math.floor((vim.o.lines - h) / 2),
    col = math.floor((vim.o.columns - w) / 2),
    border = "rounded",
    title = " " .. os.date("%A, %d %B") .. " ",
    title_pos = "center",
  })

  -- match markview's expected window options; avoid style="minimal" which kills signcolumn
  local wo = vim.wo[state.win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = "yes"
  wo.foldcolumn = "0"
  wo.colorcolumn = ""
  wo.spell = false
  wo.wrap = true
  wo.cursorline = true
  wo.conceallevel = 2
  wo.concealcursor = "nc"

  set_close_keymaps(state.buf)

  -- reset augroup so we don't stack autocmds across reopens
  vim.api.nvim_create_augroup("DailiesFloat", { clear = true })

  -- re-bind close keymaps whenever a new buffer enters the float
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
      if state.win and vim.api.nvim_win_is_valid(state.win)
        and vim.api.nvim_get_current_win() == state.win then
        set_close_keymaps(vim.api.nvim_get_current_buf())
      end
    end,
  })

  -- auto-close when focus leaves the float
  vim.api.nvim_create_autocmd("WinLeave", {
    group = augroup,
    callback = function()
      if vim.api.nvim_get_current_win() == state.win then
        vim.schedule(close)
      end
    end,
  })

  -- safety net: if the window is destroyed by :q, :bdelete, etc.
  vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    pattern = tostring(state.win),
    once = true,
    callback = function()
      save_float_buf()
      state.win = nil
      vim.api.nvim_create_augroup("DailiesFloat", { clear = true })
    end,
  })
end

function M.setup()
  vim.keymap.set("n", "<leader>j", toggle, { desc = "Toggle daily tasks" })
end

return M
