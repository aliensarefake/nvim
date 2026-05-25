-- Autocommands Configuration
-- Commands that run automatically on specific events

-- For more information:
-- :help autocmd
-- :help events

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
-- Briefly highlight text when copying
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    (vim.hl or vim.highlight).on_yank({
      higroup = "IncSearch", 
      timeout = 150,
      on_visual = false,
      priority = 250
    })
  end,
})

-- Resize splits when window is resized
augroup("ResizeSplits", { clear = true })
autocmd("VimResized", {
  group = "ResizeSplits",
  command = "tabdo wincmd =",
})

-- Return to last edit position when opening files
augroup("LastEditPosition", { clear = true })
autocmd("BufReadPost", {
  group = "LastEditPosition",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-create directories when saving a file
augroup("AutoCreateDir", { clear = true })
autocmd("BufWritePre", {
  group = "AutoCreateDir",
  callback = function(event)
    if event.match:match("^%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if not vim.uv.fs_stat(dir) then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Close certain windows with 'q'
augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group = "QuickClose",
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Disable auto-comment on new lines
augroup("DisableAutoComment", { clear = true })
autocmd("BufEnter", {
  group = "DisableAutoComment",
  command = "set formatoptions-=cro",
})

augroup("WrapText", { clear = true })
autocmd("FileType", {
  group = "WrapText",
  pattern = { "markdown", "gitcommit" },
  callback = function()
    -- vim.opt_local.wrap = true
    vim.opt_local.spell = false
    vim.opt_local.conceallevel = 2
  end,
})

-- Set specific tab settings for certain filetypes
augroup("FileTypeSettings", { clear = true })
autocmd("FileType", {
  group = "FileTypeSettings",
  pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Auto-reload files changed outside of Neovim
augroup("AutoReload", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = "AutoReload",
  command = "if mode() != 'c' | checktime | endif",
})

-- Terminal settings
augroup("TerminalSettings", { clear = true })
autocmd("TermOpen", {
  group = "TerminalSettings",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})