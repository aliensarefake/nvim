-- Shared telescope layout: preview right, results left, consistent across find/grep/lsp
local M = {}

M.horizontal = {
  preview_width = 0.65,
  results_width = 0.35,
  width = 0.95,
  height = 0.85,
  preview_cutoff = 0,
}

function M.with_preview(opts)
  return vim.tbl_deep_extend("force", {
    layout_strategy = "horizontal",
    layout_config = { horizontal = M.horizontal },
    sorting_strategy = "ascending",
  }, opts or {})
end

-- Variant for LSP pickers — opens in normal mode with nicer borders
function M.lsp_dropdown(opts)
  return vim.tbl_deep_extend("force", M.with_preview(), {
    initial_mode = "normal",
    prompt_prefix = " ",
    selection_caret = "> ",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  }, opts or {})
end

return M
