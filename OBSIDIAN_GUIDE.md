# Creating Notes
- :ObsidianNew [title] - Creates new note
- :ObsidianToday - Creates/opens today's daily note
- Location: Check current workspace with :ObsidianWorkspace

# Linking Syntax
[[Note Title]]                    # Link to note
[[Note Title#Header]]            # Link to header
[[Note Title#^block-id]]         # Link to block
[[Note Title|Display Text]]      # Link with alias

# Creating Links in Insert Mode
- Type [[ and Obsidian will autocomplete
- Use Tab/Shift-Tab to navigate suggestions

# Text Formatting
*italic* or _italic_
**bold** or __bold__
***bold italic*** or ___bold italic___
~~strikethrough~~
==highlight== (if supported)

# Lists & Checkboxes
- [ ] Todo item
- [x] Completed item
- [>] Migrated item
- [~] Cancelled item
  - Nested item
    1. Numbered subitem

# Tables
| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |

# Quick Table Creation
:TableModeToggle (requires vim-table-mode plugin)
