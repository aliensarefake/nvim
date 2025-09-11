return {
  -- Mason tool installer for linters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "eslint_d",
          "shellcheck",
          "luacheck",
          "yamllint",
          "jsonlint",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },
  
  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
    local lint = require("lint")
    
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      lua = { "luacheck" },
      yaml = { "yamllint" },
      json = { "jsonlint" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },
    }
    
    -- Ensure Mason-installed linters are found
    local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin/")
    for name, linter_config in pairs(lint.linters) do
      if type(linter_config) == "table" and linter_config.cmd then
        local cmd = linter_config.cmd
        if vim.fn.executable(cmd) == 0 and vim.fn.executable(mason_bin .. cmd) == 1 then
          linter_config.cmd = mason_bin .. cmd
        end
      end
    end
    
    -- Create autocommand for linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
    
    -- Manual lint command
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, {})
    end,
  },
}