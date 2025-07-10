-- Treesitter Configuration
-- Advanced syntax highlighting and code understanding

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- List of parsers to install
      ensure_installed = {
        "c",
        "cpp",
        "javascript",
        "typescript",
        "python",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "json",
        "yaml",
        "toml",
        "html",
        "css",
        "bash",
        "regex",
        "diff",
        "git_config",
        "gitignore",
        "gitcommit",
        "git_rebase",
        "gitattributes",
      },
      
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      
      -- List of parsers to ignore installing
      ignore_install = {},
      
      highlight = {
        enable = true,
        
        -- Disable highlighting for large files
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time
        additional_vim_regex_highlighting = false,
      },
      
      -- Indentation based on treesitter
      indent = {
        enable = true,
        disable = { "yaml" }, -- YAML indentation can be problematic
      },
      
      -- Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      
      -- Text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
            ["as"] = "@statement.outer",
          },
        },
      },
    })
    
    -- Folding based on treesitter
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false -- Don't fold by default
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}