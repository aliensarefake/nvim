-- Global Keymaps Configuration
-- Custom keyboard shortcuts that work across all modes

-- For more information on keymaps:
-- :help vim.keymap.set
-- :help map-modes

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Smart window split function
-- Splits vertically if window is wide, horizontally if tall
local function smart_split()
  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)

  if win_width > win_height * 2.5 then
    vim.cmd("vsplit")
  else
    vim.cmd("split")
  end
end

-- Window management
keymap("n", "<leader>ws", smart_split, { desc = "Smart split window" })
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Equal window sizes" })
keymap("n", "<leader>wc", ":close<CR>", { desc = "Close window" })
keymap("n", "<leader>wo", ":only<CR>", { desc = "Close other windows" })

-- Resize windows with hjkl (using Alt/Option) — only when splits exist
keymap("n", "<M-k>", function() if vim.fn.winnr("$") > 1 then vim.cmd("resize +2") end end, opts)
keymap("n", "<M-j>", function() if vim.fn.winnr("$") > 1 then vim.cmd("resize -2") end end, opts)
keymap("n", "<M-h>", function() if vim.fn.winnr("$") > 1 then vim.cmd("vertical resize -2") end end, opts)
keymap("n", "<M-l>", function() if vim.fn.winnr("$") > 1 then vim.cmd("vertical resize +2") end end, opts)

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>bc", ":bdelete!<CR>", { desc = "Force delete buffer" })

-- Stay in indent mode (use < and > keys directly, or Shift+, and Shift+.)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "<S-,>", "<gv", opts)
keymap("v", "<S-.>", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Save file
keymap("n", "<C-s>", ":w<CR>", { desc = "Save file" })
keymap("i", "<C-s>", "<C-o>:w<CR>", { desc = "Save file" })

-- Quit shortcuts
keymap("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" })
keymap("n", "<leader>qw", ":q<CR>", { desc = "Quit window" })
keymap("n", "<leader>qf", ":q!<CR>", { desc = "Force quit" })

-- Better navigation in insert mode (removed C-h as it conflicts with backspace)
keymap("i", "<C-l>", "<Right>", opts)
keymap("i", "<C-j>", "<Down>", opts)
keymap("i", "<C-k>", "<Up>", opts)

-- Ctrl+Backspace to delete word in insert mode (various terminal escape sequences)
keymap("i", "<C-BS>", "<C-w>", opts)
-- Removed <C-H> mapping as it conflicts with normal mode switching
keymap("i", "<M-BS>", "<C-w>", opts)

-- Quick escape (commented out to avoid accidental triggers)
-- keymap("i", "jk", "<ESC>", opts)
-- keymap("i", "kj", "<ESC>", opts)

-- Navigate quickfix list
keymap("n", "<leader>cn", ":cnext<CR>", { desc = "Next quickfix" })
keymap("n", "<leader>cp", ":cprevious<CR>", { desc = "Previous quickfix" })
keymap("n", "<leader>co", ":copen<CR>", { desc = "Open quickfix" })
keymap("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix" })

-- Toggle relative line numbers
keymap("n", "<leader>lr", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative line numbers" })

-- Toggle diagnostics (per-buffer). Useful for muting pyright/eslint on WIP code.
keymap("n", "<leader>ud", function()
  local on = vim.diagnostic.is_enabled({ bufnr = 0 })
  vim.diagnostic.enable(not on, { bufnr = 0 })
  vim.notify("Diagnostics " .. (on and "off" or "on") .. " for buffer", vim.log.levels.INFO)
end, { desc = "Toggle diagnostics (buffer)" })

keymap("n", "<leader>uD", function()
  local on = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not on)
  vim.notify("Diagnostics " .. (on and "off" or "on") .. " globally", vim.log.levels.INFO)
end, { desc = "Toggle diagnostics (global)" })

-- Center cursor after jumping
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Diagnostic keymaps live in lsp.lua ([d, ]d, <leader>ld, <leader>lq)

-- Tab/Shift-Tab for indent/unindent in all modes
keymap("n", "<Tab>", ">>", { desc = "Indent line" })
keymap("n", "<S-Tab>", "<<", { desc = "Unindent line" })
keymap("v", "<Tab>", ">gv", { desc = "Indent selection", silent = true })
keymap("v", "<S-Tab>", "<gv", { desc = "Unindent selection", silent = true })
keymap("i", "<Tab>", "<C-t>", { desc = "Indent" })
keymap("i", "<S-Tab>", "<C-d>", { desc = "Unindent" })

-- Multi-replace/delete keymaps (current buffer)
keymap("n", "<leader>mr", function()
  local word = vim.fn.expand("<cword>")
  local input = vim.fn.input("Search pattern (default: " .. word .. "): ", word)
  if input == "" then return end

  local replacement = vim.fn.input("Replace with: ")
  if replacement == nil then return end

  vim.cmd("%s/\\<" .. input .. "\\>/" .. replacement .. "/gc")
end, { desc = "Replace word in buffer" })

keymap("n", "<leader>md", function()
  local word = vim.fn.expand("<cword>")
  local input = vim.fn.input("Delete pattern (default: " .. word .. "): ", word)
  if input == "" then return end

  vim.cmd("%s/\\<" .. input .. "\\>//gc")
end, { desc = "Delete word in buffer" })

-- Multi-file search and replace
keymap("n", "<leader>mR", function()
  require("spectre").open()
end, { desc = "Replace across files (Spectre)" })

keymap("n", "<leader>mw", function()
  require("spectre").open_visual({select_word=true})
end, { desc = "Replace word across files" })

keymap("v", "<leader>mR", function()
  require("spectre").open_visual()
end, { desc = "Replace selection across files" })

-- Markdown buffer-local keymaps live in ftplugin/markdown.lua
