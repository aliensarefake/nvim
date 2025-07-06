-- Tools Plugin
-- Obsidian.nvim for note-taking integration

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  enabled = true,  -- Set to false to disable Obsidian plugin
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- Create Obsidian directories if they don't exist
    local personal_path = vim.fn.expand("~/Documents/Obsidian/Personal")
    local work_path = vim.fn.expand("~/Documents/Obsidian/Work")
    
    vim.fn.mkdir(personal_path, "p")
    vim.fn.mkdir(work_path, "p")
    
    require("obsidian").setup({
      workspaces = {
        {
          name = "notes",
          path = vim.fn.expand("~/notes"),
        },
        {
          name = "personal",
          path = personal_path,
        },
        {
          name = "work",
          path = work_path,
        },
      },
      
      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- Linux
      end,
      
      -- Optional, completion.
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      
      -- Optional, configure key mappings. These are the defaults.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },
      
      -- Optional, customize how names/IDs for new notes are created.
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      
      -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
      image_name_func = function()
        -- Prefix image names with timestamp.
        return string.format("%s-", os.time())
      end,
      
      -- Optional, boolean or a function that takes a filename and returns a boolean.
      disable_frontmatter = false,
      
      -- Optional, alternatively you can customize the frontmatter data.
      note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      
      -- Optional, for templates (see below).
      templates = {
        subdir = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      
      -- Optional, by default when you use `:ObsidianOpen`, the app will open in the background.
      open_app_in_background = false,
      
      -- Optional, configure additional syntax highlighting / extmarks.
      ui = {
        enable = true,
        update_debounce = 200,
        -- Define how various check-boxes are displayed
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        },
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },
      
      -- Optional, by default commands like `:ObsidianSearch` will attempt to use
      -- telescope.nvim, fzf-lua, or fzf.vim (in that order), and use the
      -- first one they find. You can set this option to tell obsidian.nvim to
      -- always use this finder.
      finder = "telescope.nvim",
    })
    
    -- Optional, override the default keymaps
    vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian note" })
    vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian app" })
    vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search Obsidian notes" })
    vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch note" })
    vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })
    vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Search tags" })
    vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Daily note" })
    vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday's note" })
    vim.keymap.set("n", "<leader>om", "<cmd>ObsidianTomorrow<cr>", { desc = "Tomorrow's note" })
    vim.keymap.set("n", "<leader>oi", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste image" })
    vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
  end,
}