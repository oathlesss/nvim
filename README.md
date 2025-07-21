# Neovim Configuration

A modern, minimal Neovim configuration built around the [mini.nvim](https://github.com/echasnovski/mini.nvim) ecosystem with LSP support and essential development tools.

## Requirements

- Neovim 0.11+
- Git (for plugin management)

## Features

### Core Functionality
- **Plugin Management**: Uses [`mini.deps`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md) for lightweight dependency management
- **LSP Support**: Pre-configured language servers for Go, Lua, TypeScript, and Python
- **File Navigation**: [Oil.nvim](https://github.com/stevearc/oil.nvim) for directory editing and [Harpoon](https://github.com/ThePrimeagen/harpoon) for quick file switching
- **Fuzzy Finding**: Built-in picker with [`mini.pick`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pick.md) for files, buffers, and live grep
- **Git Integration**: Visual diff, git commands, and commit history browsing with [`mini.git`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-git.md) and [`mini.diff`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-diff.md)
- **Task Running**: [Overseer](https://github.com/stevearc/overseer.nvim) for task management and execution

### Mini.nvim Modules
- **[mini.align](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md)**: Text alignment
- **[mini.animate](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-animate.md)**: Smooth cursor animations
- **[mini.basics](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-basics.md)**: Essential Neovim settings and mappings
- **[mini.bracketed](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md)**: Bracket navigation
- **[mini.bufremove](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bufremove.md)**: Buffer removal utilities
- **[mini.clue](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-clue.md)**: Contextual key binding hints
- **[mini.colors](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-colors.md)**: Color utilities
- **[mini.comment](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md)**: Smart commenting
- **[mini.completion](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-completion.md)**: Intelligent autocompletion
- **[mini.cursorword](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md)**: Highlight word under cursor
- **[mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md)**: Plugin dependency management
- **[mini.diff](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-diff.md)**: Git diff visualization
- **[mini.doc](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-doc.md)**: Documentation generation
- **[mini.extra](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-extra.md)**: Extra functionality
- **[mini.files](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-files.md)**: File explorer
- **[mini.fuzzy](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-fuzzy.md)**: Fuzzy matching
- **[mini.git](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-git.md)**: Git integration
- **[mini.hipatterns](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-hipatterns.md)**: Syntax highlighting for TODOs, colors, and password masking
- **[mini.icons](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-icons.md)**: Icon support
- **[mini.indentscope](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md)**: Visual indent guides
- **[mini.jump](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-jump.md)**: Jump to locations
- **[mini.jump2d](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-jump2d.md)**: 2D jumping
- **[mini.map](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-map.md)**: Code minimap
- **[mini.misc](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-misc.md)**: Miscellaneous utilities
- **[mini.move](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-move.md)**: Move text objects
- **[mini.notify](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-notify.md)**: Notification system
- **[mini.operators](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-operators.md)**: Text operators
- **[mini.pick](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pick.md)**: Fuzzy picker for files, buffers, and live grep
- **[mini.snippets](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-snippets.md)**: Snippet support
- **[mini.splitjoin](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-splitjoin.md)**: Split/join code constructs
- **[mini.statusline](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md)**: Clean, informative status bar
- **[mini.surround](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md)**: Text object manipulation
- **[mini.trailspace](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md)**: Trailing whitespace management
- **[mini.visits](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-visits.md)**: Track file visits

### Additional Plugins
- **[Oil.nvim](https://github.com/stevearc/oil.nvim)**: File manager for directory editing
- **[Harpoon](https://github.com/ThePrimeagen/harpoon)**: Quick file navigation and bookmarking
- **[Barbecue](https://github.com/utilyre/barbecue.nvim)**: LSP-powered breadcrumb navigation
- **[Undotree](https://github.com/mbbill/undotree)**: Visual undo history
- **[Overseer](https://github.com/stevearc/overseer.nvim)**: Task runner and job management
- **[Supermaven](https://github.com/supermaven-inc/supermaven-nvim)**: AI-powered code completion

### Colorschemes
- **[Vague](https://github.com/vague2k/vague.nvim)**: Default colorscheme
- **[Rose Pine](https://github.com/rose-pine/neovim)**: Alternative colorscheme option

## Installation

1. Clone this configuration:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

2. Start Neovim - `mini.nvim` will be automatically installed on first run

## Key Bindings

### Leader Keys
- **Leader**: `<Space>`
- **Local Leader**: `<Enter>`

### File Operations
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fG` - Grep word under cursor
- `<leader><space>` - Switch buffers
- `<leader>e` - Open Oil file manager

### LSP
- `gd` - Go to definition
- `<leader>ls` - Show document symbols
- `<leader>lr` - Rename symbol
- `<leader>la` - Code actions
- `<leader>le` - Show diagnostics
- `<leader>bf` - Format buffer

### Git
- `<leader>gb` - Git log for current file
- `<leader>gd` - Toggle visual diff
- `<leader>gh` - Git range history
- `<leader>ga` - Git add all
- `<leader>gc` - Quick commit with "wip" message

### Utilities
- `<leader>ut` - Toggle undotree
- `<leader>or` - Run Overseer task
- `<leader>fc` - Change colorscheme
- `<leader>up` - Toggle password masking
- `YY` - Yank entire buffer
- `<Esc>` - Clear search highlights

## Language Server Configuration

Pre-configured LSP servers in the `lsp/` directory:
- **Go**: [`gopls`](https://pkg.go.dev/golang.org/x/tools/gopls) - Official Go language server
- **Lua**: [`lua_ls`](https://github.com/LuaLS/lua-language-server) - Lua language server
- **TypeScript/JavaScript**: [`ts_ls`](https://github.com/typescript-language-server/typescript-language-server) - TypeScript language server
- **Python**: [`basedpyright`](https://github.com/DetachHead/basedpyright) - Python language server based on Pyright

See the [Adding LSP Servers Guide](docs/adding-lsp.md) for instructions on adding new language servers.

## Documentation

Comprehensive guides are available in the `docs/` directory:

- **[Adding LSP Servers](docs/adding-lsp.md)** - Guide for adding new language servers
- **[Adding Plugins](docs/adding-plugins.md)** - How to add new plugins with mini.deps
- **[Customization](docs/customization.md)** - Modifying options, keybinds, and settings
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions

## Customization

The configuration is modular with separate files for different concerns:
- `lua/core/options.lua` - Vim options and settings
- `lua/core/keybinds.lua` - Key mappings
- `lua/core/mini-modules.lua` - Mini.nvim plugin configurations
- `lua/core/lsp.lua` - LSP setup
- `lsp/*.lua` - Individual language server configurations

See the [Customization Guide](docs/customization.md) for detailed instructions on modifying the configuration.

## Notable Features

- **Smart Folding**: Tree-sitter based folding with all folds open by default
- **Persistent Undo**: 10,000 levels of undo history
- **Password Masking**: Automatically hide sensitive information in files
- **Smooth Scrolling**: Enhanced scrolling experience
- **Auto-formatting**: LSP-based formatting with fallback to Vim's built-in formatter