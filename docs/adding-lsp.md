# Adding a New Language Server

This guide explains how to add a new Language Server Protocol (LSP) server to your Neovim configuration using Neovim's built-in LSP capabilities.

## Step 1: Create the LSP Configuration File

1. Create a new file in the `lsp/` directory named after your language server:
   ```bash
   touch lsp/your_language_server.lua
   ```

2. Use the following template for your LSP configuration:

```lua
---@type vim.lsp.Config
return {
    -- Command to start the language server
    cmd = { "your-language-server", "--stdio" },
    
    -- Root directory markers (files that indicate project root)
    root_markers = { "package.json", "Cargo.toml", "go.mod", ".git" },
    
    -- File types this server should attach to
    filetypes = { "javascript", "typescript", "rust", "go" },
    
    -- Optional: Custom initialization function
    on_init = function(client)
        -- Configure server-specific settings
        client.settings = vim.tbl_deep_extend('force', client.settings or {}, {
            -- Server-specific settings here
            -- Example for rust-analyzer:
            -- ["rust-analyzer"] = {
            --     cargo = {
            --         allFeatures = true,
            --     },
            -- },
        })
    end,
    
    -- Optional: Custom attach function
    on_attach = function(client, bufnr)
        -- Add custom keybindings or configurations here
        -- The global LSP keybindings from lua/core/lsp.lua will still apply
    end,
}
```

## Step 2: Enable the Language Server

Add your new language server to `lua/core/lsp.lua`:

```lua
-- Add this line with the other vim.lsp.enable calls
vim.lsp.enable('your_language_server')
```

## Step 3: Install the Language Server

Make sure the language server binary is installed on your system. Common installation methods:

### Package Managers
```bash
# npm (for JavaScript/TypeScript servers)
npm install -g your-language-server

# cargo (for Rust-based servers)
cargo install your-language-server

# go (for Go-based servers)
go install github.com/example/your-language-server@latest

# pip (for Python-based servers)
pip install your-language-server
```

### System Package Managers
```bash
# macOS with Homebrew
brew install your-language-server

# Ubuntu/Debian
sudo apt install your-language-server

# Arch Linux
sudo pacman -S your-language-server
```

## Step 3: Verify Installation

1. Restart Neovim
2. Open a file of the target language
3. Check if LSP is attached: `:lua print(vim.inspect(vim.lsp.get_clients()))`
4. Test LSP functionality:
   - `gd` - Go to definition
   - `<leader>lr` - Rename symbol
   - `<leader>la` - Code actions

## Example: Adding Rust Analyzer

Here's a complete example for adding rust-analyzer:

1. Create `lsp/rust_analyzer.lua`:
```lua
---@type vim.lsp.Config
return {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    filetypes = { "rust" },
    on_init = function(client)
        client.settings = vim.tbl_deep_extend('force', client.settings or {}, {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
                procMacro = {
                    enable = true,
                },
            },
        })
    end,
}
```

2. Add to `lua/core/lsp.lua`:
```lua
vim.lsp.enable('rust_analyzer')
```

3. Install rust-analyzer:
```bash
rustup component add rust-analyzer
```

## Common Language Servers

| Language | Server | Installation |
|----------|--------|--------------|
| Rust | rust-analyzer | `rustup component add rust-analyzer` |
| C/C++ | clangd | `brew install llvm` or system package |
| Java | jdtls | Download from Eclipse JDT |
| HTML | html | `npm install -g vscode-langservers-extracted` |
| CSS | cssls | `npm install -g vscode-langservers-extracted` |
| JSON | jsonls | `npm install -g vscode-langservers-extracted` |
| Bash | bashls | `npm install -g bash-language-server` |
| Docker | dockerls | `npm install -g dockerfile-language-server-nodejs` |

## Troubleshooting

### LSP Not Starting
1. Check if the language server binary is in your PATH: `which your-language-server`
2. Check Neovim logs: `:messages`
3. Check LSP logs: `:LspLog`

### No Completions
- Ensure `capabilities` is set correctly in your LSP setup
- Verify `mini.completion` is loaded before LSP setup

### Custom Settings Not Working
- Check the language server's documentation for correct settings format
- Some servers use different setting structures

## References

- [Neovim LSP documentation](https://neovim.io/doc/user/lsp.html)
- [vim.lsp.Config documentation](https://neovim.io/doc/user/lsp.html#vim.lsp.Config)
- [Language Server Protocol specification](https://microsoft.github.io/language-server-protocol/)
- [nvim-lspconfig server configurations](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) (for reference on server settings)
