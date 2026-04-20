-- Utility functions for productivity
-- Quick capture, macro helpers, and workflow enhancements

local M = {}

--------------------------------------------------------------------------------
-- QUICK CAPTURE
--------------------------------------------------------------------------------
-- Capture a thought without leaving your current buffer
-- Usage: <leader>ni to capture, later review ~/notes/inbox.md

M.inbox_path = vim.fn.expand("~/notes/inbox.md") -- Change this to your inbox location

function M.quick_capture()
  local thought = vim.fn.input("Capture: ")
  if thought == "" then
    return
  end

  local timestamp = os.date("%Y-%m-%d %H:%M")
  local entry = string.format("- [ ] %s: %s", timestamp, thought)

  -- Ensure directory exists
  local dir = vim.fn.fnamemodify(M.inbox_path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  -- Append to inbox
  local file = io.open(M.inbox_path, "a")
  if file then
    file:write(entry .. "\n")
    file:close()
    vim.notify("Captured: " .. thought:sub(1, 40) .. (thought:len() > 40 and "..." or ""), vim.log.levels.INFO)
  else
    vim.notify("Failed to write to inbox", vim.log.levels.ERROR)
  end
end

-- Quick capture with priority tag
function M.quick_capture_priority()
  local priorities = { "high", "medium", "low" }
  vim.ui.select(priorities, { prompt = "Priority:" }, function(priority)
    if not priority then return end
    local thought = vim.fn.input("Capture (" .. priority .. "): ")
    if thought == "" then return end

    local timestamp = os.date("%Y-%m-%d %H:%M")
    local entry = string.format("- [ ] %s [%s]: %s", timestamp, priority, thought)

    local file = io.open(M.inbox_path, "a")
    if file then
      file:write(entry .. "\n")
      file:close()
      vim.notify("Captured (" .. priority .. ")", vim.log.levels.INFO)
    end
  end)
end

--------------------------------------------------------------------------------
-- MACRO HELPERS
--------------------------------------------------------------------------------
-- Make macros more usable with visibility and persistence

-- Show what's in a register before executing
function M.peek_macro()
  local reg = vim.fn.input("Peek register (a-z): ")
  if reg == "" then return end
  local content = vim.fn.getreg(reg)
  if content == "" then
    vim.notify("Register '" .. reg .. "' is empty", vim.log.levels.WARN)
  else
    -- Make control characters visible
    local readable = content:gsub("\027", "<Esc>"):gsub("\r", "<CR>"):gsub("\n", "<NL>")
    vim.notify("Register '" .. reg .. "': " .. readable, vim.log.levels.INFO)
  end
end

-- Execute macro with confirmation (shows content first)
function M.execute_macro_safe()
  local reg = vim.fn.input("Execute macro from register (a-z): ")
  if reg == "" then return end
  local content = vim.fn.getreg(reg)
  if content == "" then
    vim.notify("Register '" .. reg .. "' is empty", vim.log.levels.WARN)
    return
  end
  local readable = content:gsub("\027", "<Esc>"):gsub("\r", "<CR>"):gsub("\n", "<NL>")
  local confirm = vim.fn.input("Execute: " .. readable:sub(1, 50) .. "? (y/n): ")
  if confirm == "y" then
    vim.cmd("normal! @" .. reg)
  end
end

-- Edit macro in a buffer (much easier than re-recording)
function M.edit_macro()
  local reg = vim.fn.input("Edit macro in register (a-z): ")
  if reg == "" or not reg:match("^[a-z]$") then return end

  local content = vim.fn.getreg(reg)

  -- Create a scratch buffer
  vim.cmd("new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_name(0, "Edit Macro @" .. reg)

  -- Insert macro content
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { content })

  -- Instructions
  vim.notify("Edit the macro, then :w to save back to register '" .. reg .. "'", vim.log.levels.INFO)

  -- Save back to register on write
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = 0,
    callback = function()
      local new_content = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
      vim.fn.setreg(reg, new_content)
      vim.notify("Macro saved to register '" .. reg .. "'", vim.log.levels.INFO)
      vim.bo.modified = false
    end,
  })
end

-- Visual indicator when recording macro
local recording_namespace = vim.api.nvim_create_namespace("macro_recording")

function M.setup_recording_indicator()
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      vim.opt.cmdheight = 1
      local reg = vim.fn.reg_recording()
      vim.api.nvim_echo({ { " RECORDING @" .. reg .. " ", "ErrorMsg" } }, false, {})
    end,
  })

  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      vim.api.nvim_echo({ { "" } }, false, {})
      local reg = vim.fn.reg_recording()
      -- Small delay to get the recorded content
      vim.defer_fn(function()
        -- reg_recording returns empty after RecordingLeave, use v:event
        vim.notify("Macro recorded", vim.log.levels.INFO)
      end, 100)
    end,
  })
end

--------------------------------------------------------------------------------
-- NAMED MACROS (Persistent)
--------------------------------------------------------------------------------
-- Save macros with human-readable names that persist across sessions

local macro_file = vim.fn.stdpath("data") .. "/saved_macros.lua"

function M.load_saved_macros()
  local ok, macros = pcall(dofile, macro_file)
  if ok and type(macros) == "table" then
    return macros
  end
  return {}
end

function M.save_macros_to_file(macros)
  local file = io.open(macro_file, "w")
  if file then
    file:write("return {\n")
    for name, content in pairs(macros) do
      -- Escape special characters
      local escaped = content:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\027", "\\027")
      file:write(string.format('  ["%s"] = "%s",\n', name, escaped))
    end
    file:write("}\n")
    file:close()
  end
end

function M.save_named_macro()
  local reg = vim.fn.input("Save from register (a-z): ")
  if not reg:match("^[a-z]$") then return end

  local content = vim.fn.getreg(reg)
  if content == "" then
    vim.notify("Register is empty", vim.log.levels.WARN)
    return
  end

  local name = vim.fn.input("Macro name: ")
  if name == "" then return end

  local macros = M.load_saved_macros()
  macros[name] = content
  M.save_macros_to_file(macros)
  vim.notify("Saved macro '" .. name .. "'", vim.log.levels.INFO)
end

function M.load_named_macro()
  local macros = M.load_saved_macros()
  local names = vim.tbl_keys(macros)

  if #names == 0 then
    vim.notify("No saved macros", vim.log.levels.WARN)
    return
  end

  vim.ui.select(names, { prompt = "Load macro:" }, function(name)
    if not name then return end
    local reg = vim.fn.input("Load to register (a-z): ")
    if reg:match("^[a-z]$") then
      vim.fn.setreg(reg, macros[name])
      vim.notify("Loaded '" .. name .. "' to @" .. reg, vim.log.levels.INFO)
    end
  end)
end

function M.run_named_macro()
  local macros = M.load_saved_macros()
  local names = vim.tbl_keys(macros)

  if #names == 0 then
    vim.notify("No saved macros", vim.log.levels.WARN)
    return
  end

  vim.ui.select(names, { prompt = "Run macro:" }, function(name)
    if not name then return end
    -- Load to register z temporarily and execute
    vim.fn.setreg("z", macros[name])
    vim.cmd("normal! @z")
  end)
end

function M.delete_named_macro()
  local macros = M.load_saved_macros()
  local names = vim.tbl_keys(macros)

  if #names == 0 then
    vim.notify("No saved macros", vim.log.levels.WARN)
    return
  end

  vim.ui.select(names, { prompt = "Delete macro:" }, function(name)
    if not name then return end
    macros[name] = nil
    M.save_macros_to_file(macros)
    vim.notify("Deleted macro '" .. name .. "'", vim.log.levels.INFO)
  end)
end

--------------------------------------------------------------------------------
-- SETUP
--------------------------------------------------------------------------------

function M.setup()
  -- Recording indicator
  M.setup_recording_indicator()

  -- Quick capture keymaps
  vim.keymap.set("n", "<leader>ni", M.quick_capture, { desc = "Quick capture to inbox" })
  vim.keymap.set("n", "<leader>nI", M.quick_capture_priority, { desc = "Quick capture with priority" })
  vim.keymap.set("n", "<leader>no", function()
    vim.cmd("edit " .. M.inbox_path)
  end, { desc = "Open inbox" })

  -- Macro keymaps (under <leader>M for Macro)
  vim.keymap.set("n", "<leader>Mp", M.peek_macro, { desc = "Peek macro register" })
  vim.keymap.set("n", "<leader>Me", M.edit_macro, { desc = "Edit macro in buffer" })
  vim.keymap.set("n", "<leader>Ms", M.save_named_macro, { desc = "Save macro with name" })
  vim.keymap.set("n", "<leader>Ml", M.load_named_macro, { desc = "Load named macro" })
  vim.keymap.set("n", "<leader>Mr", M.run_named_macro, { desc = "Run named macro" })
  vim.keymap.set("n", "<leader>Md", M.delete_named_macro, { desc = "Delete named macro" })
end

return M
