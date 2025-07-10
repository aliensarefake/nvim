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

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Alternative resize with Alt + hjkl (bigger steps)
keymap("n", "<A-h>", ":vertical resize -5<CR>", opts)
keymap("n", "<A-l>", ":vertical resize +5<CR>", opts)
keymap("n", "<A-j>", ":resize -5<CR>", opts)
keymap("n", "<A-k>", ":resize +5<CR>", opts)

-- Window size presets
keymap("n", "<leader>w1", ":vertical resize 80<CR>", { desc = "Set width to 80" })
keymap("n", "<leader>w2", ":vertical resize 120<CR>", { desc = "Set width to 120" })
keymap("n", "<leader>wm", "<C-w>_<C-w>|", { desc = "Maximize window" })

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>bc", ":bdelete!<CR>", { desc = "Force delete buffer" })

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down (using Shift+J/K instead of Alt to avoid conflict)
keymap("v", "<S-j>", ":m .+1<CR>==", opts)
keymap("v", "<S-k>", ":m .-2<CR>==", opts)
keymap("x", "<S-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<S-k>", ":move '<-2<CR>gv-gv", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Clear search highlighting
keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Save file
keymap("n", "<C-s>", ":w<CR>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })

-- Quit shortcuts
keymap("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" })
keymap("n", "<leader>qw", ":q<CR>", { desc = "Quit window" })
keymap("n", "<leader>qf", ":q!<CR>", { desc = "Force quit" })

-- Better navigation in insert mode (removed C-k to avoid conflict with window navigation)
keymap("i", "<C-h>", "<Left>", opts)
keymap("i", "<C-l>", "<Right>", opts)
keymap("i", "<C-j>", "<Down>", opts)
-- keymap("i", "<C-k>", "<Up>", opts) -- Commented out to allow window navigation

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

-- Center cursor after jumping
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Tab/Shift-Tab for indent/unindent in all modes
keymap("n", "<Tab>", ">>", { desc = "Indent line", noremap = true })
keymap("n", "<S-Tab>", "<<", { desc = "Unindent line", noremap = true })
keymap("v", "<Tab>", ">gv", { desc = "Indent selection", noremap = true, silent = true })
keymap("v", "<S-Tab>", "<gv", { desc = "Unindent selection", noremap = true, silent = true })
keymap("x", "<Tab>", ">gv", { desc = "Indent selection", noremap = true, silent = true })
keymap("x", "<S-Tab>", "<gv", { desc = "Unindent selection", noremap = true, silent = true })
-- Note: Insert mode Tab is handled by nvim-cmp
-- keymap("i", "<Tab>", "<C-t>", { desc = "Indent" })
-- keymap("i", "<S-Tab>", "<C-d>", { desc = "Unindent" })

-- Multi-replace/delete keymaps
keymap("n", "<leader>mr", function()
  local word = vim.fn.expand("<cword>")
  local input = vim.fn.input("Search pattern (default: " .. word .. "): ", word)
  if input == "" then return end

  local replacement = vim.fn.input("Replace with: ")
  if replacement == nil then return end

  vim.cmd("%s/\\<" .. input .. "\\>/" .. replacement .. "/gc")
end, { desc = "Replace word globally" })

keymap("n", "<leader>md", function()
  local word = vim.fn.expand("<cword>")
  local input = vim.fn.input("Delete pattern (default: " .. word .. "): ", word)
  if input == "" then return end

  vim.cmd("%s/\\<" .. input .. "\\>//gc")
end, { desc = "Delete word globally" })

-- Markdown formatting keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local opts = { buffer = true }
    
    -- Bold
    keymap("v", "<leader>mb", "c**<C-r>\"**<Esc>", vim.tbl_extend("force", opts, { desc = "Bold selection" }))
    keymap("n", "<leader>mb", "viw<Esc>a**<Esc>bi**<Esc>", vim.tbl_extend("force", opts, { desc = "Bold word" }))
    
    -- Italic
    keymap("v", "<leader>mi", "c*<C-r>\"*<Esc>", vim.tbl_extend("force", opts, { desc = "Italic selection" }))
    keymap("n", "<leader>mi", "viw<Esc>a*<Esc>bi*<Esc>", vim.tbl_extend("force", opts, { desc = "Italic word" }))
    
    -- Strikethrough
    keymap("v", "<leader>ms", "c~~<C-r>\"~~<Esc>", vim.tbl_extend("force", opts, { desc = "Strikethrough selection" }))
    keymap("n", "<leader>ms", "viw<Esc>a~~<Esc>bi~~<Esc>", vim.tbl_extend("force", opts, { desc = "Strikethrough word" }))
    
    -- Code
    keymap("v", "<leader>mc", "c`<C-r>\"`<Esc>", vim.tbl_extend("force", opts, { desc = "Code selection" }))
    keymap("n", "<leader>mc", "viw<Esc>a`<Esc>bi`<Esc>", vim.tbl_extend("force", opts, { desc = "Code word" }))
    
    -- Highlight
    keymap("v", "<leader>mh", "c==<C-r>\"==<Esc>", vim.tbl_extend("force", opts, { desc = "Highlight selection" }))
    keymap("n", "<leader>mh", "viw<Esc>a==<Esc>bi==<Esc>", vim.tbl_extend("force", opts, { desc = "Highlight word" }))
    
    -- Toggle checkbox
    keymap("n", "<leader>mt", function()
      local line = vim.api.nvim_get_current_line()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      
      if line:match("^%s*%- %[[ x]%]") then
        if line:match("^%s*%- %[ %]") then
          line = line:gsub("^(%s*%- )%[ %]", "%1[x]")
        else
          line = line:gsub("^(%s*%- )%[x%]", "%1[ ]")
        end
        vim.api.nvim_set_current_line(line)
      elseif line:match("^%s*%- ") then
        line = line:gsub("^(%s*%- )", "%1[ ] ")
        vim.api.nvim_set_current_line(line)
      else
        vim.api.nvim_put({"- [ ] "}, "c", true, false)
      end
    end, vim.tbl_extend("force", opts, { desc = "Toggle checkbox" }))
  end,
})
