# Debugging in Neovim (DAP)

This configuration enables full IDE-like debugging capabilities using `nvim-dap` and `nvim-dap-ui`.

## ⚡ Quick Start

1.  **Open a file** (Python, Rust, etc.).
2.  **Set a breakpoint** with `<Leader>db`.
3.  **Start Debugging** with `<F5>`.
4.  The Debug UI will automatically open.

## 🗝️ Keymaps

| Key              | Description                                   |
| :--------------- | :-------------------------------------------- | --- |
| **`<leader>dc`** | **Start / Continue** (Launches debug session) |
| **`<leader>do`** | **Step Over** (Next line)                     |
| **`<leader>di`** | **Step Into** (Go inside function)            |
| **`<leader>dO`** | **Step Out** (Return from function)           |
| **`<leader>db`** | **Toggle Breakpoint**                         |     |
| **`<leader>dB`** | Set Conditional Breakpoint                    |     |
| **`<leader>du`** | Toggle Debug UI manually                      |     |
| **`<leader>de`** | Evaluate expression                           |     |
| **`<leader>dr`** | Open REPL (Debug Console)                     |     |
| **`<leader>dl`** | Run Last                                      |     |

## 🛠️ Languages Supported

### 🐍 Python

- **Debugger:** `debugpy` (Auto-installed via Mason)
- **Plugin:** `nvim-dap-python`
- **Usage:** Just press `<F5>` in any `.py` file. It automatically detects the python path.

### 🦀 Rust (and C/C++)

- **Debugger:** `codelldb` (Auto-installed via Mason)
- **Usage:**
  1.  Ensure you have built your project: `cargo build`
  2.  Open a `.rs` file.
  3.  Press `<F5>`.
  4.  It will prompt you for the **Path to executable**. Select your binary (usually in `target/debug/your_project_name`).

## 📦 Installed Components

- `mfussenegger/nvim-dap`: The core Debug Adapter Protocol client.
- `rcarriga/nvim-dap-ui`: The fancy sidebar UI (Stacks, Scopes, Watches).
- `jay-babu/mason-nvim-dap.nvim`: Bridges Mason installers with DAP.
- `theHamsta/nvim-dap-virtual-text`: Shows variable values inline in the code.
