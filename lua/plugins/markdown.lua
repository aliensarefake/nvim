-- Markdown Enhancement Plugins
-- Better markdown rendering and preview

return {
  -- Headlines.nvim for better markdown rendering
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "markdown", "org", "norg" },
    config = function()
      require("headlines").setup({
        markdown = {
          query = vim.treesitter.query.parse(
            "markdown",
            [[
              (atx_heading [
                (atx_h1_marker)
                (atx_h2_marker)
                (atx_h3_marker)
                (atx_h4_marker)
                (atx_h5_marker)
                (atx_h6_marker)
              ] @headline)

              (thematic_break) @dash

              (fenced_code_block) @codeblock

              (block_quote_marker) @quote
              (block_quote (paragraph (inline (block_continuation) @quote)))
              (block_quote (paragraph (block_continuation) @quote))
              (block_quote (block_continuation) @quote)
            ]]
          ),
          headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
          },
          bullet_highlights = {
            "@text.title.1.marker.markdown",
            "@text.title.2.marker.markdown",
            "@text.title.3.marker.markdown",
            "@text.title.4.marker.markdown",
            "@text.title.5.marker.markdown",
            "@text.title.6.marker.markdown",
          },
          bullets = { "◉", "○", "✸", "✿" },
          codeblock_highlight = "CodeBlock",
          dash_highlight = "Dash",
          dash_string = "-",
          quote_highlight = "Quote",
          quote_string = "┃",
          fat_headlines = true,
          fat_headline_upper_string = "▄",
          fat_headline_lower_string = "▀",
        },
      })

      -- Define custom highlight groups
      vim.cmd [[
        highlight Headline1 guibg=#1e2718 guifg=#c9d1d9
        highlight Headline2 guibg=#21262d guifg=#c9d1d9
        highlight Headline3 guibg=#30363d guifg=#c9d1d9
        highlight Headline4 guibg=#484f58 guifg=#c9d1d9
        highlight Headline5 guibg=#484f58 guifg=#c9d1d9
        highlight Headline6 guibg=#484f58 guifg=#c9d1d9
        highlight CodeBlock guibg=#1c1c1c
        highlight Dash guifg=#484f58
        highlight Quote guifg=#484f58
      ]]
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ""
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {}
      }
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_port = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
    end,
  },

  -- Markdown formatting utilities
  {
    "antonk52/markdowny.nvim",
    ft = { "markdown" },
    config = function()
      require("markdowny").setup({
        filetypes = { "markdown" },
      })
    end,
  },

  -- Image rendering in Neovim
  {
    "3rd/image.nvim",
    ft = { "markdown" },
    config = function()
      local ok, image = pcall(require, "image")
      if not ok then
        return
      end
      image.setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = false,
            only_render_image_at_cursor = false,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      })
    end,
  },

  -- Clipboard image pasting
  {
    "HakonHarnes/img-clip.nvim",
    ft = { "markdown" },
    keys = {
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
    },
    config = function()
      require("img-clip").setup({
        default = {
          dir_path = "./images",
          file_name = "%Y-%m-%d-%H-%M-%S",
        },
        filetypes = {
          markdown = {
            relative_to_current_file = true,
            dir_path = function()
              return "images"
            end,
            template = "![$FILE_NAME_NO_EXT]($FILE_PATH)",
          },
        },
      })
    end,
  },
}