-- Fix for visual mode highlight glitches
-- Ensures proper clearing of highlights and visual selections

local M = {}

-- Clear any lingering visual mode highlights
function M.clear_visual_highlights()
  vim.cmd('nohlsearch')
  vim.cmd('redraw!')
end

-- Setup autocmds to prevent highlight glitches
function M.setup()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd
  
  -- Clear highlights when leaving visual mode
  augroup("ClearVisualHighlights", { clear = true })
  autocmd({ "ModeChanged" }, {
    group = "ClearVisualHighlights",
    pattern = "[vV\x16]*:*",
    callback = function()
      vim.schedule(function()
        vim.cmd('nohlsearch')
      end)
    end,
  })
  
  -- Clear search highlights more aggressively
  augroup("ClearSearchHighlight", { clear = true })
  autocmd({ "InsertEnter", "CursorMoved" }, {
    group = "ClearSearchHighlight",
    callback = function()
      -- Skip for markdown files
      local ft = vim.bo.filetype
      if ft == 'markdown' or ft == 'md' then
        return
      end
      
      if vim.v.hlsearch == 1 and vim.fn.mode() == 'n' then
        local key = vim.api.nvim_replace_termcodes("<Cmd>nohlsearch<CR>", true, false, true)
        vim.api.nvim_feedkeys(key, 'n', false)
      end
    end,
  })
end

return M