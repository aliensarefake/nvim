-- Neovim Configuration Entry Point
-- This file bootstraps the configuration and loads all modules in the correct order

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins
-- Space is used as the leader key for most custom mappings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Loading order is important:
-- 1. Options: Basic vim settings (line numbers, tabs, etc.)
-- 2. Keymaps: Global keyboard shortcuts
-- 3. Lazy: Plugin manager configuration
-- 4. Autocmds: Automatic commands for events

require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.autocmds")