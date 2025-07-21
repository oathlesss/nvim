# Customization Guide

This guide covers how to customize various aspects of your Neovim configuration.

## File Structure Overview

```
nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── core/
│   │   ├── options.lua      # Vim options and settings
│   │   ├── keybinds.lua     # Key mappings
│   │   ├── mini-modules.lua # Mini.nvim configurations
│   │   ├── lsp.lua          # LSP setup and keybindings
│   │   ├── autocommands.lua # Auto commands
│   │   └── *.lua            # Individual plugin configs
│   └── util.lua             # Utility functions
├── lsp/                     # Language server configurations
└── docs/                    # Documentation
```

## Modifying Vim Options

Edit `lua/core/options.lua` to change Neovim settings:

### Common Options to Customize

```lua
-- Line numbers
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers

-- Indentation
vim.opt.tabstop = 4            -- Tab width
vim.opt.shiftwidth = 4         -- Indent width
vim.opt.expandtab = true       -- Use spaces instead of tabs

-- Search
vim.opt.ignorecase = true      -- Case insensitive search
vim.opt.smartcase = true       -- Case sensitive if uppercase present

-- UI
vim.opt.wrap = false           -- Don't wrap lines
vim.opt.scrolloff = 8          -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8      -- Keep 8 columns left/right of cursor

-- Files
vim.opt.backup = false         -- Don't create backup files
vim.opt.swapfile = false       -- Don't create swap files
vim.opt.undofile = true        -- Enable persistent undo
```

### Adding New Options

Add any Vim option using the `vim.opt` API:

```lua
-- Example: Enable spell checking
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Example: Set colorcolumn
vim.opt.colorcolumn = "80"

-- Example: Configure completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
```

## Customizing Keybindings

Edit `lua/core/keybinds.lua` to modify or add key mappings:

### Understanding the Keymap Format

```lua
vim.keymap.set(mode, key, action, options)
```

- `mode`: "n" (normal), "i" (insert), "v" (visual), "x" (visual block), "c" (command)
- `key`: The key combination
- `action`: Command string or Lua function
- `options`: Table with options like `desc`, `silent`, `noremap`

### Adding Custom Keybindings

```lua
-- Simple command mapping
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Lua function mapping
vim.keymap.set("n", "<leader>h", function()
    vim.cmd("nohlsearch")
end, { desc = "Clear search highlights" })

-- Multiple modes
vim.keymap.set({"n", "v"}, "<leader>y", '"+y', { desc = "Yank to system clipboard" })

-- Insert mode mapping
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
```

### Modifying Existing Keybindings

Find the keybinding in `lua/core/keybinds.lua` and modify it:

```lua
-- Change the leader key (default is space)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Modify existing binding
vim.keymap.set("n", "<leader>ff", function()
    -- Your custom file finder logic
end, { desc = "Custom file finder" })
```

### Leader Key Groups

The configuration uses leader key groups for organization:

```lua
-- File operations
vim.keymap.set("n", "<leader>ff", ..., { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ..., { desc = "Live grep" })

-- LSP operations  
vim.keymap.set("n", "<leader>lr", ..., { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>la", ..., { desc = "Code actions" })

-- Git operations
vim.keymap.set("n", "<leader>gb", ..., { desc = "Git blame" })
vim.keymap.set("n", "<leader>gd", ..., { desc = "Git diff" })
```

## Configuring Mini.nvim Modules

Edit `lua/core/mini-modules.lua` to customize mini.nvim modules:

### Enabling/Disabling Modules

```lua
-- Disable a module by commenting it out
-- later(function() require("mini.animate").setup() end)

-- Enable a module by adding it
later(function() require("mini.sessions").setup() end)
```

### Customizing Module Settings

```lua
later(function()
    require("mini.indentscope").setup({
        symbol = "│",  -- Change indent symbol
        draw = {
            delay = 100,  -- Animation delay
            animation = function() return 20 end,  -- Animation duration
        },
    })
end)
```

### Common Mini Module Customizations

#### Statusline
```lua
later(function()
    require("mini.statusline").setup({
        content = {
            active = function()
                -- Custom statusline content
                local mode = MiniStatusline.section_mode({ trunc_width = 120 })
                local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                return MiniStatusline.combine_groups({
                    { hl = "MiniStatuslineModeNormal", strings = { mode } },
                    { hl = "MiniStatuslineFilename", strings = { filename } },
                })
            end,
        },
    })
end)
```

#### Completion
```lua
later(function()
    require("mini.completion").setup({
        delay = { completion = 100, info = 100, signature = 50 },
        window = {
            info = { height = 25, width = 80, border = "rounded" },
            signature = { height = 25, width = 80, border = "rounded" },
        },
        lsp_completion = {
            source_func = "completefunc",  -- or "omnifunc"
            auto_setup = false,
        },
    })
end)
```

#### Pick (Fuzzy Finder)
```lua
later(function()
    require("mini.pick").setup({
        mappings = {
            choose = "<CR>",
            choose_in_split = "<C-s>",
            choose_in_tabpage = "<C-t>",
            choose_in_vsplit = "<C-v>",
            choose_marked = "<M-CR>",
        },
        options = {
            content_from_bottom = false,
            use_cache = true,
        },
        window = {
            config = function()
                return {
                    anchor = "NW",
                    height = math.floor(0.618 * vim.o.lines),
                    width = math.floor(0.618 * vim.o.columns),
                    row = math.floor(0.1 * vim.o.lines),
                    col = math.floor(0.1 * vim.o.columns),
                }
            end,
        },
    })
end)
```

## Customizing LSP

Edit `lua/core/lsp.lua` to modify LSP behavior:

### Global LSP Settings

```lua
-- Customize diagnostic display
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",  -- Change diagnostic prefix
        source = "always",  -- Show diagnostic source
    },
    float = {
        source = "always",  -- Show source in floating window
        border = "rounded",  -- Change border style
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Customize diagnostic signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
```

### LSP Keybindings

Modify the `on_attach` function in `lua/core/lsp.lua`:

```lua
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    
    -- Add custom LSP keybindings
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    
    -- Custom function keybindings
    vim.keymap.set("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end
```

### Server-Specific Customizations

Edit individual server files in the `lsp/` directory:

```lua
-- lsp/lua_ls.lua
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
    capabilities = require("mini.completion").completions_lsp_capabilities(),
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { 
                globals = { "vim" },  -- Recognize vim global
                disable = { "missing-fields" },  -- Disable specific diagnostics
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})
```

## Changing Colorschemes

### Adding New Colorschemes

Edit `lua/core/colorschemes.lua`:

```lua
local add, now = MiniDeps.add, MiniDeps.now

now(function()
    -- Add new colorschemes
    add({ source = 'catppuccin/nvim' })
    add({ source = 'folke/tokyonight.nvim' })
    add({ source = 'EdenEast/nightfox.nvim' })
    
    -- Set default colorscheme
    vim.cmd('colorscheme catppuccin-mocha')
end)
```

### Colorscheme-Specific Configuration

```lua
now(function()
    add({ source = 'catppuccin/nvim' })
    require("catppuccin").setup({
        flavour = "mocha",  -- latte, frappe, macchiato, mocha
        background = {
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
        },
        integrations = {
            mini = true,
            harpoon = true,
            mason = true,
            which_key = true,
        },
    })
    vim.cmd('colorscheme catppuccin')
end)
```

## Auto Commands

Edit `lua/core/autocommands.lua` to add custom auto commands:

```lua
-- Create augroup for organization
local augroup = vim.api.nvim_create_augroup("CustomAutoCommands", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- Auto-save on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
    group = augroup,
    pattern = "*",
    command = "silent! wa",
})

-- Set filetype-specific options
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "python", "lua" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

-- Auto-format on save for specific filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = { "*.lua", "*.py", "*.js", "*.ts" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
```

## Plugin-Specific Customizations

### Oil.nvim
Edit `lua/core/oil.lua`:

```lua
require("oil").setup({
    columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
    },
    buf_options = {
        buflisted = false,
        bufhidden = "hide",
    },
    win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
    },
})
```

### Harpoon
Edit `lua/core/harpoon.lua`:

```lua
local harpoon = require("harpoon")
harpoon:setup({
    settings = {
        save_on_toggle = false,
        sync_on_ui_close = true,
        key = function()
            return vim.loop.cwd()
        end,
    },
})

-- Custom keybindings
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Quick access to first 4 files
for i = 1, 4 do
    vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end)
end
```

## Performance Tuning

### Startup Optimization

```lua
-- In init.lua, add performance settings
vim.loader.enable()  -- Enable Lua module cache

-- Disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Reduce updatetime for better responsiveness
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
```

### Lazy Loading Optimization

Move more plugins to `later()` loading:

```lua
-- Instead of now()
later(function()
    -- Plugin setup
end)
```

## Environment-Specific Configuration

Create conditional configurations:

```lua
-- Check if running in specific environments
if vim.fn.has("mac") == 1 then
    -- macOS specific settings
    vim.opt.clipboard = "unnamed"
elseif vim.fn.has("unix") == 1 then
    -- Linux specific settings
    vim.opt.clipboard = "unnamedplus"
end

-- Check for specific tools
if vim.fn.executable("rg") == 1 then
    -- Use ripgrep if available
    vim.opt.grepprg = "rg --vimgrep --smart-case --follow"
end
```

## Debugging Configuration Issues

### Check Configuration Loading

```lua
-- Add debug prints to see what's loading
print("Loading configuration file: " .. debug.getinfo(1).source)
```

### Profile Startup Time

```bash
nvim --startuptime startup.log
```

### Check Plugin Status

```vim
:lua MiniDeps.show_log()
:messages
:checkhealth
```

## References

- [Neovim Lua guide](https://neovim.io/doc/user/lua-guide.html)
- [Mini.nvim documentation](https://github.com/echasnovski/mini.nvim)
- [Neovim options](https://neovim.io/doc/user/options.html)