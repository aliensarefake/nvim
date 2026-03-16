-- Markdown Enhancement Plugins
-- Better markdown rendering and preview

return {
	-- markview.nvim - Comprehensive markdown rendering
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "norg", "rmd", "org" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("markview").setup({
				-- Rendering modes
				modes = { "n", "no", "c" }, -- Normal, operator-pending, command mode
				hybrid_modes = { "n" }, -- Enable hybrid mode in normal mode

				-- Callbacks for custom behavior
				callbacks = {
					on_enable = function(_, win)
						vim.wo[win].conceallevel = 3
						vim.wo[win].concealcursor = "nc"
					end,
				},

				-- Headings configuration
				headings = {
					enable = true,
					shift_width = 0,
					heading_1 = {
						style = "label",
						sign = "󰼏 ",
						padding_left = " ",
						padding_right = " ",
						corner_right = " ",
						hl = "MarkviewHeading1",
					},
					heading_2 = {
						style = "label",
						sign = "󰎨 ",
						padding_left = " ",
						padding_right = " ",
						corner_right = " ",
						hl = "MarkviewHeading2",
					},
					heading_3 = {
						style = "label",
						sign = "󰼑 ",
						padding_left = " ",
						padding_right = " ",
						corner_right = " ",
						hl = "MarkviewHeading3",
					},
					heading_4 = {
						style = "label",
						sign = "󰎲 ",
						padding_left = " ",
						padding_right = " ",
						corner_right = " ",
						hl = "MarkviewHeading4",
					},
					heading_5 = {
						style = "label",
						sign = "󰼓 ",
						padding_left = " ",
						padding_right = " ",
						corner_right = " ",
						hl = "MarkviewHeading5",
					},
					heading_6 = {
						style = "label",
						sign = "󰎴 ",
						padding_left = " ",
						padding_right = " ",
						corner_right = " ",
						hl = "MarkviewHeading6",
					},
				},

				-- Code blocks - Enhanced rendering with more padding
				code_blocks = {
					enable = true,
					style = "language",
					position = "overlay",
					min_width = 70,
					pad_amount = 0,
					pad_char = " ",
					hl = "MarkviewCode",
					sign = true,
					sign_hl = "MarkviewCodeSign",
					language_direction = "right",
				},

				-- Inline code - Subtle highlighting
				inline_codes = {
					enable = true,
					corner_left = "",
					corner_right = "",
					hl = "MarkviewInlineCode",
				},

				-- Highlights - ==highlighted text==
				highlights = {
					enable = true,
					hl = "MarkviewHighlight",
				},

				-- Block quotes - Visual styling
				block_quotes = {
					enable = true,
					default = {
						border = "▋",
						hl = "MarkviewBlockQuote",
					},
				},

				-- Horizontal rules
				horizontal_rules = {
					enable = true,
					parts = {
						{
							type = "repeating",
							text = "─",
							direction = "left",
							repeat_amount = function()
								local textoff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff
								return math.floor((vim.o.columns - textoff) / 2)
							end,
							hl = "MarkviewHorizontalRule",
						},
					},
				},

				-- List items - Custom markers with minimal spacing
				list_items = {
					enable = true,
					shift_width = 0,
					indent_size = 2,
					marker_minus = {
						add_padding = false,
						text = "•",
						hl = "MarkviewListItemMinus",
					},
					marker_plus = {
						add_padding = false,
						text = "➤",
						hl = "MarkviewListItemPlus",
					},
					marker_star = {
						add_padding = false,
						text = "★",
						hl = "MarkviewListItemStar",
					},
					marker_dot = {
						add_padding = false,
						text = "•",
						hl = "MarkviewListItemDot",
					},
				},

				-- Checkboxes - Enhanced icons with scope highlighting and no marker
				checkboxes = {
					enable = true,
					marker_minus = { add_padding = false, text = "" },
					marker_plus = { add_padding = false, text = "" },
					marker_star = { add_padding = false, text = "" },
					checked = {
						text = " ",
						scope_hl = "MarkviewCheckboxChecked",
					},
					unchecked = {
						text = " ",
						scope_hl = "MarkviewCheckboxUnchecked",
					},
					pending = {
						text = "󰥔 ",
						scope_hl = "MarkviewCheckboxPending",
					},
					custom = {
						{
							match = "~",
							text = "󰰱 ",
							scope_hl = "MarkviewCheckboxCancelled",
						},
						{
							match = ">",
							text = " ",
							scope_hl = "MarkviewCheckboxForwarded",
						},
					},
				},

				-- Tables - Border and alignment
				tables = {
					enable = true,
					text = {
						"╭",
						"─",
						"╮",
						"├",
						"┤",
						"╰",
						"╯",
						"│",
					},
					hl = {
						"MarkviewTableHeader",
						"MarkviewTableBorder",
						"MarkviewTableHeader",
						"MarkviewTableBorder",
						"MarkviewTableBorder",
						"MarkviewTableBorder",
						"MarkviewTableBorder",
						"MarkviewTableBorder",
					},
					use_virt_lines = true,
				},

				-- Links - Clean display
				links = {
					enable = true,
					hyperlinks = {
						icon = " ",
						hl = "MarkviewHyperlink",
					},
					images = {
						icon = " ",
						hl = "MarkviewImage",
					},
					emails = {
						icon = " ",
						hl = "MarkviewEmail",
					},
					internal_links = {
						icon = " ",
						hl = "MarkviewInternalLink",
					},
				},

				-- LaTeX - Math rendering
				latex = {
					enable = true,
					inline = {
						enable = false,
					},
					block = {
						enable = true,
						hl = "MarkviewLatexBlock",
					},
				},

				-- HTML - Inline HTML support
				html = {
					enable = true,
					tags = {
						enable = true,
					},
					entities = {
						enable = true,
					},
				},
			})

			-- Custom highlight groups
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					-- Headings with backgrounds
					vim.api.nvim_set_hl(0, "MarkviewHeading1", { bg = "#3d2828", fg = "#ff6e6e", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewHeading2", { bg = "#3d3328", fg = "#ff9e64", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewHeading3", { bg = "#3d3b28", fg = "#ffd766", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewHeading4", { bg = "#283d37", fg = "#73daca", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewHeading5", { bg = "#28333d", fg = "#7aa2f7", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewHeading6", { bg = "#33283d", fg = "#bb9af7", bold = true })

					-- Code blocks with distinct background (more padding instead of borders)
					vim.api.nvim_set_hl(0, "MarkviewCode", { bg = "#16161e" })
					vim.api.nvim_set_hl(0, "MarkviewCodeSign", { fg = "#7aa2f7" })
					vim.api.nvim_set_hl(0, "MarkviewInlineCode", { bg = "#283457", fg = "#bb9af7" })

					-- Highlights (==text==)
					vim.api.nvim_set_hl(0, "MarkviewHighlight", { bg = "#3d3410", fg = "#ffd766" })

					-- Block quotes
					vim.api.nvim_set_hl(0, "MarkviewBlockQuote", { fg = "#7aa2f7" })

					-- Horizontal rules
					vim.api.nvim_set_hl(0, "MarkviewHorizontalRule", { fg = "#3b4261" })

					-- Lists
					vim.api.nvim_set_hl(0, "MarkviewListItemMinus", { fg = "#7aa2f7" })
					vim.api.nvim_set_hl(0, "MarkviewListItemPlus", { fg = "#9ece6a" })
					vim.api.nvim_set_hl(0, "MarkviewListItemStar", { fg = "#ff9e64" })
					vim.api.nvim_set_hl(0, "MarkviewListItemDot", { fg = "#7dcfff" })

					-- Checkboxes with improved appearance
					vim.api.nvim_set_hl(0, "MarkviewCheckboxChecked", { fg = "#9ece6a", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewCheckboxUnchecked", { fg = "#545c7e", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewCheckboxPending", { fg = "#ff9e64", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewCheckboxCancelled", { fg = "#f7768e", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewCheckboxForwarded", { fg = "#7dcfff", bold = true })

					-- Tables
					vim.api.nvim_set_hl(0, "MarkviewTableHeader", { fg = "#7aa2f7", bold = true })
					vim.api.nvim_set_hl(0, "MarkviewTableBorder", { fg = "#3b4261" })

					-- Links
					vim.api.nvim_set_hl(0, "MarkviewHyperlink", { fg = "#7aa2f7", underline = true })
					vim.api.nvim_set_hl(0, "MarkviewImage", { fg = "#bb9af7" })
					vim.api.nvim_set_hl(0, "MarkviewEmail", { fg = "#7dcfff", underline = true })
					vim.api.nvim_set_hl(0, "MarkviewInternalLink", { fg = "#9ece6a", underline = true })

					-- LaTeX
					vim.api.nvim_set_hl(0, "MarkviewLatexInline", { fg = "#bb9af7" })
					vim.api.nvim_set_hl(0, "MarkviewLatexBlock", { bg = "#1a1b26", fg = "#bb9af7" })
				end,
			})

			-- Apply highlights immediately
			vim.cmd("doautocmd ColorScheme")

			-- Keymaps for markview control (no conflicts with existing markdown keymaps)
			vim.keymap.set("n", "<leader>mv", "<cmd>Markview toggle<cr>", { desc = "Toggle Markview" })
			vim.keymap.set("n", "<leader>mS", "<cmd>Markview splitToggle<cr>", { desc = "Toggle Markview Split" })
			vim.keymap.set("n", "<leader>mH", "<cmd>Markview hybridToggle<cr>", { desc = "Toggle Markview Hybrid" })
		end,
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && npm install",
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
		},
		config = function()
			local css_dir = vim.fn.expand("~/.config/nvim/markdown-preview-css")

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
				toc = {},
			}
			vim.g.mkdp_markdown_css = css_dir .. "/markdown.css"
			vim.g.mkdp_highlight_css = css_dir .. "/highlight.css"
			vim.g.mkdp_port = ""
			vim.g.mkdp_page_title = "「${name}」"
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_theme = "dark"
		end,
	},

	-- Image rendering in Neovim with luarocks support
	{
		"3rd/image.nvim",
		ft = { "markdown" },
		rocks = { "magick" }, -- installs via luarocks so require("magick") works
		config = function()
			local ok, image = pcall(require, "image")
			if not ok then
				vim.notify("image.nvim failed to load", vim.log.levels.WARN)
				return
			end
			image.setup({
				backend = "kitty", -- Kitty protocol (works with Ghostty)
				integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = false,
						only_render_image_at_cursor = false,
					},
				},
				tmux_show_only_in_active_window = true,
				max_width = 50,
				max_height = 12,
				window_overlap_clear_enabled = true,
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
