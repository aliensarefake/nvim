-- Shared floating window helpers for flashcard UI
local M = {}

function M.open_float(opts)
  opts = opts or {}
  local w = math.floor(vim.o.columns * (opts.width or 0.7))
  local h = math.floor(vim.o.lines * (opts.height or 0.6))

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w,
    height = h,
    row = math.floor((vim.o.lines - h) / 2),
    col = math.floor((vim.o.columns - w) / 2),
    border = "rounded",
    title = opts.title and (" " .. opts.title .. " ") or nil,
    title_pos = opts.title and "center" or nil,
  })

  local wo = vim.wo[win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = "no"
  wo.foldcolumn = "0"
  wo.colorcolumn = ""
  wo.spell = false
  wo.wrap = true
  wo.cursorline = false
  wo.conceallevel = 2
  wo.concealcursor = "nc"

  return buf, win
end

function M.set_buf_lines(buf, lines)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

function M.close(win)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
end

function M.bind_close(buf, win)
  local kopts = { buffer = buf, silent = true, nowait = true }
  vim.keymap.set("n", "q", function() M.close(win) end, kopts)
  vim.keymap.set("n", "<Esc>", function() M.close(win) end, kopts)
end

return M
