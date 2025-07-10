# Neovim Configuration

A modular, performance-optimized Neovim configuration with LSP support, advanced UI enhancements, and comprehensive plugin ecosystem.

## 📋 Prerequisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Node.js (for some LSP servers)
- Python 3 (for Python LSP)
- C/C++ compiler (for treesitter and some tools)
- ripgrep (for telescope grep)
- fd (optional, for better file finding)

## 🚀 Installation

1. **Backup your existing configuration** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone or copy this configuration**:
   ```bash
   # If using git
   git clone <your-repo> ~/.config/nvim
   
   # Or simply copy the files
   cp -r /path/to/this/config ~/.config/nvim
   ```

3. **Launch Neovim**:
   ```bash
   nvim
   ```
   
   On first launch:
   - Lazy.nvim will automatically install
   - All plugins will be downloaded and configured
   - LSP servers will be installed via Mason
   - Treesitter parsers will be installed

4. **Install LSP servers** (if not automatic):
   ```vim
   :Mason
   ```
   Then install: clangd, tsserver, pyright

## 🏗️ Structure

```
~/.config/nvim/
├── init.lua                 # Entry point, loads all modules
└── lua/
    ├── config/             # Core configuration
    │   ├── lazy.lua        # Plugin manager setup
    │   ├── options.lua     # Vim options (line numbers, tabs, etc.)
    │   ├── keymaps.lua     # Global keybindings
    │   └── autocmds.lua    # Automatic commands
    └── plugins/            # Plugin configurations
        ├── colorscheme.lua # Tokyo Night theme
        ├── ui.lua          # UI enhancements (lualine, bufferline, etc.)
        ├── editor.lua      # Editor features (oil, telescope, etc.)
        ├── lsp.lua         # Language Server Protocol
        ├── completion.lua  # Autocompletion
        ├── treesitter.lua  # Syntax highlighting
        ├── navigation.lua  # Flash.nvim for quick navigation
        └── tools.lua       # Additional tools (obsidian)
```

## ⌨️ Key Mappings

### Leader Key
- `<Space>` - Leader key

### Essential Navigation
- `<C-h/j/k/l>` - Navigate between windows
- `s` - Flash jump (quick navigation)
- `S` - Flash treesitter jump
- `-` - Open file explorer (oil.nvim)
- `<leader>-` - Open file explorer in float

### Window Management
- `<leader>ws` - Smart split (vertical if wide, horizontal if tall)
- `<leader>wv` - Vertical split
- `<leader>wh` - Horizontal split
- `<leader>wc` - Close window
- `<leader>wo` - Close other windows
- `<leader>we` - Equal window sizes

### Buffer Navigation
- `<Tab>` - Next buffer
- `<S-Tab>` - Previous buffer
- `<S-h>` - Previous buffer (alternative)
- `<S-l>` - Next buffer (alternative)
- `<leader>bd` - Delete buffer
- `<leader>bp` - Pin buffer

### Telescope (Fuzzy Finder)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags
- `<leader>fw` - Find word under cursor
- `<leader>fr` - Recent files
- `<leader>f/` - Fuzzy find in current buffer

### LSP
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Find references
- `K` - Hover documentation
- `<C-k>` - Signature help
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `<leader>lf` - Format buffer
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

### Completion
- `<Tab>` - Next completion item / expand snippet
- `<S-Tab>` - Previous completion item
- `<CR>` - Confirm completion
- `<C-Space>` - Trigger completion
- `<C-e>` - Abort completion

### Comments
- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `gc` (visual) - Comment selection
- `gb` (visual) - Block comment selection

### Surround
- `ys{motion}{char}` - Add surround
- `ds{char}` - Delete surround
- `cs{target}{replacement}` - Change surround

### Folding
- `zR` - Open all folds
- `zM` - Close all folds
- `za` - Toggle fold
- `K` - Peek fold (or hover if not on fold)

### Git (if integrated)
- `<leader>gg` - Open git status
- `<leader>gb` - Git blame
- `<leader>gd` - Git diff

## 🔧 Configuration

### Adding New Plugins

1. Create a new file in `lua/plugins/` or add to existing category
2. Return a table with plugin specification:
   ```lua
   return {
     "author/plugin-name",
     config = function()
       require("plugin-name").setup({
         -- options
       })
     end,
   }
   ```
3. Restart Neovim or run `:Lazy sync`

### Modifying Existing Plugins

1. Open the relevant file in `lua/plugins/`
2. Modify the configuration
3. Reload with `:source %` or restart Neovim

### Changing Options

- Edit `lua/config/options.lua` for general settings
- Edit `lua/config/keymaps.lua` for keybindings
- Edit `lua/config/autocmds.lua` for automatic commands

## 🐛 Debugging Issues

### Plugin Issues
```vim
:Lazy                  " Open plugin manager
:Lazy sync            " Update all plugins
:Lazy clean           " Remove unused plugins
:Lazy log             " View plugin log
:checkhealth          " General health check
```

### LSP Issues
```vim
:LspInfo              " View LSP status
:LspLog               " View LSP log
:Mason                " Open Mason UI
:MasonLog             " View Mason log
```

### Treesitter Issues
```vim
:TSInstallInfo        " View parser status
:TSUpdate             " Update parsers
:TSModuleInfo         " View module info
```

### General Debugging
```vim
:messages             " View recent messages
:scriptnames          " List loaded scripts
:verbose set option?  " Check where option was set
```

## 📚 Learning Resources

### Understanding the Config
- Start with `init.lua` to see the loading order
- Each file in `lua/config/` has extensive comments
- Plugin configurations include links to documentation

### Vim/Neovim Resources
- `:help` - Built-in documentation
- `:Tutor` - Interactive tutorial
- [Neovim docs](https://neovim.io/doc/)
- [Vim Cheatsheet](https://vim.rtorr.com/)

### Plugin Documentation
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting

## 🎨 Customization Tips

1. **Change colorscheme**: Edit `lua/plugins/colorscheme.lua`
2. **Modify statusline**: Edit the lualine config in `lua/plugins/ui.lua`
3. **Add custom snippets**: Create them in the completion config
4. **Change leader key**: Edit the setting in `init.lua`
5. **Disable a plugin**: Comment it out or set `enabled = false`

## ⚡ Performance Tips

1. **Lazy loading**: Most plugins are already configured for lazy loading
2. **Disable unused plugins**: Comment out or remove from plugin files
3. **Reduce startup time**: Use `:StartupTime` to profile
4. **Limit treesitter parsers**: Only install languages you use

## 🆘 Common Issues

### Icons not showing
- Install a [Nerd Font](https://www.nerdfonts.com/)
- Set your terminal to use the Nerd Font

### LSP not working
- Ensure language servers are installed: `:Mason`
- Check prerequisites (node, python, etc.)
- Run `:checkhealth`

### Slow startup
- Run `:StartupTime` to identify slow plugins
- Disable unused plugins
- Check for synchronous operations in config

### Telescope not finding files
- Install ripgrep: `brew install ripgrep` (macOS)
- Install fd (optional): `brew install fd`