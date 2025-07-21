# Adding New Plugins

This guide explains how to add new plugins to your Neovim configuration using `mini.deps`.

## Understanding mini.deps

This configuration uses [`mini.deps`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md) for plugin management. It provides three main functions:

- `add()` - Declare a plugin dependency
- `now()` - Load and configure plugins immediately
- `later()` - Load and configure plugins after startup (lazy loading)

## Step 1: Choose Loading Strategy

### Immediate Loading (`now()`)
Use for plugins that need to be available immediately:
- Core functionality plugins
- Plugins that other plugins depend on
- UI plugins that affect startup appearance

### Lazy Loading (`later()`)
Use for plugins that can be loaded after startup:
- Most functionality plugins
- Plugins triggered by user actions
- Performance-sensitive plugins

## Step 2: Add the Plugin

### Method 1: Create a New Configuration File

1. Create a new file in `lua/core/` for your plugin:
   ```bash
   touch lua/core/your-plugin.lua
   ```

2. Use this template:
   ```lua
   local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
   
   -- For immediate loading
   now(function()
       add({ source = "author/plugin-name" })
       require("plugin-name").setup({
           -- Plugin configuration here
       })
   end)
   
   -- OR for lazy loading
   later(function()
       add({ source = "author/plugin-name" })
       require("plugin-name").setup({
           -- Plugin configuration here
       })
   end)
   ```

3. Load your configuration in `init.lua`:
   ```lua
   require("core.your-plugin")
   ```

### Method 2: Add to Existing Configuration

Add your plugin to an existing configuration file like `lua/core/mini-modules.lua`:

```lua
later(function()
    add({ source = "author/plugin-name" })
    require("plugin-name").setup({
        -- Configuration here
    })
end)
```

## Step 3: Plugin Configuration Options

### Basic Plugin Declaration
```lua
add({ source = "author/plugin-name" })
```

### Plugin with Dependencies
```lua
add({
    source = "author/plugin-name",
    depends = { "dependency1/plugin", "dependency2/plugin" },
})
```

### Plugin with Specific Branch/Tag
```lua
add({
    source = "author/plugin-name",
    checkout = "branch-name",  -- or tag name
    monitor = "branch-name",   -- branch to monitor for updates
})
```

### Plugin with Custom Installation
```lua
add({
    source = "author/plugin-name",
    hooks = {
        post_install = function()
            -- Run commands after installation
            vim.fn.system("make install")
        end,
        post_checkout = function()
            -- Run commands after updates
            vim.fn.system("make clean && make install")
        end,
    },
})
```

## Examples

### Adding a Colorscheme
```lua
-- In lua/core/colorschemes.lua or a new file
local add, now = MiniDeps.add, MiniDeps.now

now(function()
    add({ source = 'catppuccin/nvim' })
    require("catppuccin").setup({
        flavour = "mocha",
    })
    -- vim.cmd('colorscheme catppuccin')
end)
```

### Adding a File Explorer
```lua
-- In lua/core/file-explorer.lua
local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({ source = "nvim-tree/nvim-tree.lua" })
    require("nvim-tree").setup({
        view = {
            width = 30,
        },
    })
    
    -- Add keybinding
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
end)
```

### Adding a Plugin with Complex Dependencies
```lua
-- In lua/core/telescope.lua
local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({
        source = "nvim-telescope/telescope.nvim",
        depends = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
    })
    
    -- Also add the fzf native extension
    add({
        source = "nvim-telescope/telescope-fzf-native.nvim",
        hooks = {
            post_install = function()
                vim.fn.system("make")
            end,
        },
    })
    
    local telescope = require("telescope")
    telescope.setup({
        defaults = {
            file_ignore_patterns = { "node_modules", ".git/" },
        },
    })
    telescope.load_extension("fzf")
    
    -- Keybindings
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
end)
```

### Adding a Language-Specific Plugin
```lua
-- In lua/core/rust-tools.lua
local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({ source = "simrat39/rust-tools.nvim" })
    require("rust-tools").setup({
        server = {
            capabilities = require("mini.completion").completions_lsp_capabilities(),
        },
    })
end)
```

## Best Practices

### 1. Group Related Plugins
Keep related plugins in the same configuration file:
- `colorschemes.lua` - All colorschemes
- `git.lua` - Git-related plugins
- `lsp-extras.lua` - LSP enhancement plugins

### 2. Use Lazy Loading When Possible
Most plugins should use `later()` for better startup performance:
```lua
later(function()
    -- Plugin setup here
end)
```

### 3. Add Keybindings with Descriptions
Always add descriptions to keybindings:
```lua
vim.keymap.set("n", "<leader>xx", ":PluginCommand<CR>", { desc = "Plugin action" })
```

### 4. Handle Plugin Dependencies
If a plugin requires external tools, document them:
```lua
-- Requires: npm install -g some-tool
add({ source = "author/plugin-name" })
```

### 5. Test Plugin Loading
After adding a plugin:
1. Restart Neovim
2. Check for errors: `:messages`
3. Verify plugin loaded: `:lua print(require("plugin-name"))`

## Managing Plugins

### Update All Plugins
```vim
:lua MiniDeps.update()
```

### Clean Unused Plugins
```vim
:lua MiniDeps.clean()
```

### View Plugin Status
```vim
:lua MiniDeps.show_log()
```

## Common Plugin Categories

### UI Enhancement
- Status lines: `lualine.nvim`, `mini.statusline`
- Tab lines: `bufferline.nvim`, `mini.tabline`
- Indent guides: `indent-blankline.nvim`, `mini.indentscope`

### File Management
- File explorers: `nvim-tree.lua`, `oil.nvim`, `mini.files`
- Fuzzy finders: `telescope.nvim`, `fzf-lua`, `mini.pick`

### Git Integration
- Git signs: `gitsigns.nvim`, `mini.diff`
- Git UI: `fugitive.vim`, `lazygit.nvim`

### Language Support
- Treesitter: `nvim-treesitter`
- LSP enhancements: `lsp-zero.nvim`, `mason.nvim`
- Debugging: `nvim-dap`

### Productivity
- Commenting: `comment.nvim`, `mini.comment`
- Surround: `nvim-surround`, `mini.surround`
- Snippets: `luasnip`, `mini.snippets`

## Troubleshooting

### Plugin Not Loading
1. Check plugin name and author are correct
2. Verify the plugin exists on GitHub
3. Check for typos in configuration
4. Look at `:messages` for errors

### Conflicts with Existing Plugins
1. Check if functionality overlaps with mini.nvim modules
2. Disable conflicting mini modules if needed
3. Adjust plugin loading order

### Performance Issues
1. Move plugins to `later()` loading
2. Use plugin-specific lazy loading options
3. Profile startup time: `nvim --startuptime startup.log`

## References

- [mini.deps documentation](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md)
- [Awesome Neovim plugins](https://github.com/rockerBOO/awesome-neovim)
- [Plugin development guide](https://neovim.io/doc/user/lua-guide.html)
