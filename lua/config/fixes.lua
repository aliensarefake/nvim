local M = {}

function M.setup()
  vim.keymap.set("n", "<C-r>", "<C-r>", { noremap = true, silent = true, desc = "Redo" })
  
  -- Ensure Tab works in visual mode after all plugins load
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- Force visual mode Tab mappings to work
      vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true, desc = "Indent selection" })
      vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true, desc = "Unindent selection" })
      vim.keymap.set("x", "<Tab>", ">gv", { noremap = true, silent = true, desc = "Indent selection" })
      vim.keymap.set("x", "<S-Tab>", "<gv", { noremap = true, silent = true, desc = "Unindent selection" })
    end,
  })
  
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
      local opts = { buffer = true, noremap = true, silent = true }

      vim.keymap.set("v", "<Tab>", ">gv", vim.tbl_extend("force", opts, { desc = "Indent selection" }))
      vim.keymap.set("v", "<S-Tab>", "<gv", vim.tbl_extend("force", opts, { desc = "Unindent selection" }))

      vim.keymap.set("v", ">", ">gv", opts)
      vim.keymap.set("v", "<", "<gv", opts)
    end,
  })
end

return M