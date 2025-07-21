# Troubleshooting Guide

This guide helps you diagnose and fix common issues with your Neovim configuration.

## General Debugging Steps

### 1. Check Neovim Version
```bash
nvim --version
```
This configuration requires Neovim 0.11+.

### 2. Check for Errors
```vim
:messages
```
Shows recent error messages and notifications.

### 3. Check Plugin Status
```vim
:lua MiniDeps.show_log()
```
Shows plugin installation and update status.

### 4. Health Check
```vim
:checkhealth
```
Comprehensive system health check.

### 5. Minimal Configuration Test
Create a minimal `init.lua` to isolate issues:
```lua
-- Minimal test configuration
vim.opt.number = true
print("Minimal config loaded")
```

## Common Issues

### Neovim Won't Start

#### Error: "Use Neovim 0.11+"
**Cause**: Using an older version of Neovim.

**Solution**: Update Neovim:
```bash
# macOS with Homebrew
brew install --HEAD neovim

# Ubuntu/Debian
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Arch Linux
sudo pacman -S neovim

# Build from source
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

#### Error: "mini.nvim installation failed"
**Cause**: Network issues or git not available.

**Solution**:
1. Check internet connection
2. Verify git is installed: `git --version`
3. Manually clone mini.nvim:
```bash
git clone https://github.com/echasnovski/mini.nvim ~/.local/share/nvim/site/pack/deps/start/mini.nvim
```

### Plugin Issues

#### Plugins Not Loading
**Symptoms**: Features missing, commands not found.

**Diagnosis**:
```vim
:lua print(vim.inspect(MiniDeps.get_session()))
```

**Solutions**:
1. Check plugin syntax in configuration files
2. Verify plugin names and sources are correct
3. Update plugins: `:lua MiniDeps.update()`
4. Clean and reinstall: `:lua MiniDeps.clean()` then restart

#### Plugin Installation Fails
**Common errors**:
- "Repository not found"
- "Permission denied"
- "Network timeout"

**Solutions**:
1. Verify plugin repository exists on GitHub
2. Check internet connection
3. Try manual installation:
```bash
cd ~/.local/share/nvim/site/pack/deps/start/
git clone https://github.com/author/plugin-name
```

#### Plugin Conflicts
**Symptoms**: Unexpected behavior, keybinding conflicts.

**Solutions**:
1. Check for duplicate functionality between plugins
2. Disable conflicting plugins temporarily
3. Review keybinding conflicts in `:map`
4. Use plugin-specific disable options

### LSP Issues

#### LSP Server Not Starting
**Symptoms**: No completions, diagnostics, or LSP features.

**Diagnosis**:
```vim
:lua print(vim.inspect(vim.lsp.get_clients()))
:lua vim.print(vim.lsp.get_log_path())
```

**Solutions**:
1. Check if language server is installed:
```bash
# Check if server binary exists
which gopls
which lua-language-server
which typescript-language-server
which basedpyright
```

2. Install missing language servers:
```bash
# Go
go install golang.org/x/tools/gopls@latest

# Lua
brew install lua-language-server

# TypeScript
npm install -g typescript-language-server typescript

# Python
pip install basedpyright
```

3. Check LSP configuration files in `lsp/` directory
4. Verify server is enabled in `lua/core/lsp.lua` with `vim.lsp.enable('server_name')`

#### LSP Completions Not Working
**Symptoms**: No completion popup or limited completions.

**Solutions**:
1. Check if LSP completion is enabled:
```vim
:lua print(vim.lsp.completion.is_enabled())
```

2. Verify the LspAttach autocmd is working:
```vim
:autocmd LspAttach
```

3. Check LSP clients are attached:
```vim
:lua print(vim.inspect(vim.lsp.get_clients({bufnr = 0})))
```

4. Restart LSP clients:
```vim
:lua vim.lsp.stop_client(vim.lsp.get_clients())
:edit
```

#### LSP Diagnostics Issues
**Symptoms**: No error/warning highlights, or too many false positives.

**Solutions**:
1. Check diagnostic configuration in `lua/core/lsp.lua`
2. Adjust diagnostic settings:
```lua
vim.diagnostic.config({
    virtual_text = true,  -- Enable/disable virtual text
    signs = true,         -- Enable/disable signs
    underline = true,     -- Enable/disable underline
    update_in_insert = false,  -- Don't update in insert mode
})
```

3. Filter specific diagnostics in server configuration:
```lua
-- In lsp/server_name.lua
---@type vim.lsp.Config
return {
    cmd = { "server-command" },
    root_markers = { ".git" },
    filetypes = { "filetype" },
    on_init = function(client)
        client.settings = vim.tbl_deep_extend('force', client.settings or {}, {
            ["language-server"] = {
                diagnostics = {
                    disable = { "unused-variable", "missing-fields" }
                }
            }
        })
    end,
}
```

### Performance Issues

#### Slow Startup
**Symptoms**: Neovim takes several seconds to start.

**Diagnosis**:
```bash
nvim --startuptime startup.log
```

**Solutions**:
1. Move plugins from `now()` to `later()` loading
2. Disable unused providers:
```lua
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
```

3. Enable Lua loader cache:
```lua
vim.loader.enable()
```

4. Profile and optimize heavy plugins

#### High Memory Usage
**Symptoms**: Neovim consuming excessive RAM.

**Solutions**:
1. Check for memory leaks in custom functions
2. Limit history and undo levels:
```lua
vim.opt.history = 1000
vim.opt.undolevels = 1000
```

3. Disable resource-intensive features temporarily
4. Use `:lua collectgarbage()` to force garbage collection

#### Laggy Typing/Scrolling
**Symptoms**: Delayed response to keystrokes or scrolling.

**Solutions**:
1. Reduce `updatetime`:
```lua
vim.opt.updatetime = 250
```

2. Disable expensive features:
```lua
-- Disable cursor animations
-- Comment out mini.animate setup
```

3. Check for blocking operations in autocommands
4. Optimize syntax highlighting and treesitter

### Keybinding Issues

#### Keybindings Not Working
**Symptoms**: Key combinations don't trigger expected actions.

**Diagnosis**:
```vim
:map <leader>ff  " Check specific mapping
:map             " List all mappings
```

**Solutions**:
1. Check for conflicting mappings
2. Verify leader key is set correctly:
```lua
vim.g.mapleader = " "  -- Space as leader
```

3. Use correct mode in keymap:
```lua
vim.keymap.set("n", "<leader>ff", ..., { desc = "Find files" })
```

4. Check if plugin providing the command is loaded

#### Leader Key Not Working
**Symptoms**: Leader-based keybindings don't respond.

**Solutions**:
1. Ensure leader is set before keybindings:
```lua
-- Set leader first
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Then set keybindings
vim.keymap.set("n", "<leader>ff", ...)
```

2. Check terminal key interpretation
3. Verify no conflicting terminal shortcuts

### File and Directory Issues

#### Oil.nvim Not Opening
**Symptoms**: File manager doesn't open or shows errors.

**Solutions**:
1. Check Oil configuration in `lua/core/oil.lua`
2. Verify permissions for target directories
3. Check for conflicting file explorers
4. Restart Neovim after configuration changes

#### Harpoon Not Saving Files
**Symptoms**: Harpoon marks don't persist between sessions.

**Solutions**:
1. Check Harpoon configuration in `lua/core/harpoon.lua`
2. Verify write permissions in Neovim data directory:
```bash
ls -la ~/.local/share/nvim/
```

3. Check for conflicting session managers

### Git Integration Issues

#### Git Signs Not Showing
**Symptoms**: No git diff indicators in sign column.

**Solutions**:
1. Verify you're in a git repository: `git status`
2. Check `mini.diff` configuration
3. Ensure sign column is enabled:
```lua
vim.opt.signcolumn = "yes"
```

#### Git Commands Failing
**Symptoms**: Git-related keybindings show errors.

**Solutions**:
1. Verify git is installed and in PATH: `git --version`
2. Check git repository status
3. Review `mini.git` configuration

### Colorscheme Issues

#### Colorscheme Not Loading
**Symptoms**: Default colors or error messages about colorscheme.

**Solutions**:
1. Check colorscheme plugin is installed
2. Verify colorscheme name is correct:
```vim
:colorscheme <Tab>  " List available colorschemes
```

3. Set colorscheme after plugin loads:
```lua
now(function()
    add({ source = 'author/colorscheme' })
    -- Add small delay if needed
    vim.defer_fn(function()
        vim.cmd('colorscheme theme-name')
    end, 100)
end)
```

#### Colors Look Wrong
**Symptoms**: Incorrect colors or missing highlights.

**Solutions**:
1. Check terminal color support:
```lua
vim.opt.termguicolors = true
```

2. Verify terminal supports 24-bit color
3. Check colorscheme configuration options
4. Reset highlights: `:hi clear`

### Terminal and Shell Issues

#### Terminal Integration Problems
**Symptoms**: Shell commands fail or behave unexpectedly.

**Solutions**:
1. Check shell configuration:
```lua
vim.opt.shell = "/bin/zsh"  -- or your preferred shell
```

2. Verify PATH is correct:
```vim
:echo $PATH
```

3. Check terminal emulator compatibility

### Configuration File Issues

#### Syntax Errors in Lua Files
**Symptoms**: Error messages on startup mentioning specific files.

**Solutions**:
1. Check Lua syntax:
```bash
luac -p lua/core/options.lua
```

2. Look for common issues:
   - Missing commas in tables
   - Unmatched parentheses/brackets
   - Incorrect string quotes

3. Use Lua LSP for syntax checking

#### Configuration Not Loading
**Symptoms**: Changes don't take effect.

**Solutions**:
1. Restart Neovim completely
2. Check file paths are correct
3. Verify `require()` statements match file structure
4. Check for typos in filenames

## Getting Help

### Debug Information to Collect

When asking for help, provide:

1. Neovim version: `nvim --version`
2. Operating system and version
3. Error messages from `:messages`
4. LSP status from `:LspInfo`
5. Plugin status from `:lua MiniDeps.show_log()`
6. Minimal reproduction steps

### Useful Commands for Debugging

```vim
" Check loaded plugins
:lua print(vim.inspect(package.loaded))

" Check LSP clients
:lua print(vim.inspect(vim.lsp.get_clients()))

" Check LSP log path
:lua vim.print(vim.lsp.get_log_path())

" Check runtime path
:set runtimepath?

" Check current working directory
:pwd

" Check file type detection
:set filetype?

" Check syntax highlighting
:syntax

" Check available commands
:command

" Check autocommands
:autocmd

" Check key mappings
:map
:imap
:nmap
:vmap

" Check LSP completion status
:lua print(vim.lsp.completion.is_enabled())
```

### Creating Minimal Reproduction

Create a minimal `init.lua` that reproduces the issue:

```lua
-- Minimal reproduction init.lua
vim.opt.number = true

-- Only include the problematic plugin/configuration
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
    vim.cmd('echo "Installing mini.nvim" | redraw')
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/echasnovski/mini.nvim", mini_path
    })
end

require("mini.deps").setup({ path = { package = path_package } })

-- Add only the problematic configuration here
```

### Community Resources

- [Neovim GitHub Issues](https://github.com/neovim/neovim/issues)
- [Mini.nvim GitHub Issues](https://github.com/echasnovski/mini.nvim/issues)
- [r/neovim Reddit](https://www.reddit.com/r/neovim/)
- [Neovim Discord](https://discord.gg/neovim)

## Prevention Tips

1. **Regular Updates**: Keep Neovim and plugins updated
2. **Backup Configuration**: Use git to track configuration changes
3. **Test Changes**: Test configuration changes in isolation
4. **Read Documentation**: Check plugin documentation before configuration
5. **Use Health Checks**: Run `:checkhealth` regularly
6. **Monitor Performance**: Profile startup time periodically