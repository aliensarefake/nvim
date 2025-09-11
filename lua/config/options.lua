-- Neovim Options Configuration
-- Basic settings that affect how Neovim behaves

-- For a full list of options, run :help options in Neovim

local opt = vim.opt

-- Line Numbers
opt.number = true             -- Show absolute line numbers
opt.relativenumber = true     -- Show relative line numbers
opt.numberwidth = 4          -- Set width of line number column

-- Tabs and Indentation
opt.tabstop = 4              -- Number of spaces a tab counts for
opt.shiftwidth = 4           -- Number of spaces for auto-indent
opt.expandtab = true         -- Convert tabs to spaces
opt.autoindent = true        -- Copy indent from current line
opt.smartindent = true       -- Smart autoindenting

-- Line Wrapping
opt.wrap = false             -- Don't wrap lines
opt.linebreak = true         -- Wrap lines at convenient points

-- Search Settings
opt.ignorecase = true        -- Ignore case when searching
opt.smartcase = true         -- Override ignorecase if uppercase is used
opt.hlsearch = true          -- Highlight search results
opt.incsearch = true         -- Show matches while typing

-- Appearance
opt.termguicolors = true     -- Enable 24-bit RGB colors
opt.signcolumn = "yes"       -- Always show sign column
opt.cursorline = true        -- Highlight current line
opt.scrolloff = 8            -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8        -- Keep 8 columns left/right of cursor
opt.pumheight = 10           -- Maximum items in popup menu
opt.showmode = false         -- Don't show mode (statusline handles this)

-- Split Windows
opt.splitright = true        -- Split vertical windows to the right
opt.splitbelow = true        -- Split horizontal windows below

-- Backup and Undo
opt.backup = false           -- Don't create backup files
opt.writebackup = false      -- Don't create backup before overwriting
opt.swapfile = false         -- Don't create swap files
opt.undofile = true          -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Completion
opt.completeopt = "menuone,noselect,noinsert"  -- Better completion experience
opt.shortmess:append("c")    -- Don't show completion messages

-- Timing
opt.updatetime = 300         -- Balanced update time for diagnostics
opt.timeoutlen = 500         -- Time to wait for mapped sequence

-- Folding (for nvim-ufo)
opt.foldcolumn = "1"         -- Show fold column
opt.foldlevel = 99           -- Start with all folds open
opt.foldlevelstart = 99      -- Start with all folds open
opt.foldenable = true        -- Enable folding

-- Miscellaneous
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.mouse = "a"              -- Enable mouse support
opt.cmdheight = 1            -- Command line height
opt.conceallevel = 0         -- Show concealed text
opt.laststatus = 3           -- Global statusline
opt.fillchars = { eob = " " } -- Remove ~ from empty lines
opt.formatoptions:remove({ "c", "r", "o" }) -- Don't auto-continue comments

-- Neovim specific
opt.inccommand = "split"     -- Show effects of substitution incrementally

-- Global variables
vim.g.loaded_netrw = 1       -- Disable netrw (using oil.nvim instead)
vim.g.loaded_netrwPlugin = 1