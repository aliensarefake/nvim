-- Markdown buffer-local keymaps (formatting, checkbox toggle, wiki links)
-- Runs once per markdown buffer via Neovim's ftplugin mechanism.

local keymap = vim.keymap.set
local opts = { buffer = true }

-- Wrap [count] word(s) forward from cursor with left/right delimiters
local function wrap_words(left, right)
  return function()
    local count = vim.v.count1
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1] - 1
    local col = pos[2]
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

    local start = col + 1
    while start > 1 and line:sub(start - 1, start - 1):match("%w") do
      start = start - 1
    end

    local i = start
    local words_found = 0
    local finish = start
    while i <= #line and words_found < count do
      if line:sub(i, i):match("%w") then
        while i <= #line and line:sub(i, i):match("%w") do
          i = i + 1
        end
        finish = i - 1
        words_found = words_found + 1
      else
        i = i + 1
      end
    end

    local new_line = line:sub(1, start - 1) .. left .. line:sub(start, finish) .. right .. line:sub(finish + 1)
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
    vim.api.nvim_win_set_cursor(0, { row + 1, start + 1 })
  end
end

keymap("v", "<leader>mb", 'c**<C-r>"**<Esc>', vim.tbl_extend("force", opts, { desc = "Bold selection" }))
keymap("n", "<leader>mb", wrap_words("**", "**"), vim.tbl_extend("force", opts, { desc = "Bold [count] word(s)" }))

keymap("v", "<leader>mi", 'c*<C-r>"*<Esc>', vim.tbl_extend("force", opts, { desc = "Italic selection" }))
keymap("n", "<leader>mi", wrap_words("*", "*"), vim.tbl_extend("force", opts, { desc = "Italic [count] word(s)" }))

keymap("v", "<leader>ms", 'c~~<C-r>"~~<Esc>', vim.tbl_extend("force", opts, { desc = "Strikethrough selection" }))
keymap("n", "<leader>ms", wrap_words("~~", "~~"), vim.tbl_extend("force", opts, { desc = "Strikethrough [count] word(s)" }))

keymap("v", "<leader>mc", 'c`<C-r>"`<Esc>', vim.tbl_extend("force", opts, { desc = "Code selection" }))
keymap("n", "<leader>mc", wrap_words("`", "`"), vim.tbl_extend("force", opts, { desc = "Code [count] word(s)" }))

keymap("v", "<leader>mh", 'c==<C-r>"==<Esc>', vim.tbl_extend("force", opts, { desc = "Highlight selection" }))
keymap("n", "<leader>mh", wrap_words("==", "=="), vim.tbl_extend("force", opts, { desc = "Highlight [count] word(s)" }))

keymap("n", "<leader>mt", function()
  local line = vim.api.nvim_get_current_line()
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
    vim.api.nvim_put({ "- [ ] " }, "c", true, false)
  end
end, vim.tbl_extend("force", opts, { desc = "Toggle checkbox" }))

keymap("v", "<leader>ml", 'c[[<C-r>"]]<Esc>', vim.tbl_extend("force", opts, { desc = "Wrap selection in [[ ]]" }))
keymap("n", "<leader>ml", wrap_words("[[", "]]"), vim.tbl_extend("force", opts, { desc = "Wiki link [count] word(s)" }))
