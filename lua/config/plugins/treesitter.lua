return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    -- See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 
	"bash", 
	"c", 
	"diff", 
	"html", 
	"lua", 
	"luadoc", 
	"markdown", 
	"markdown_inline", 
	"query", 
	"vim", 
	"vimdoc",
	"python",
	"htmldjango",
	"go",
	"css",
      },
      auto_install = true,
      highlight = {
	enable = true,
      },
      indent = { enable = true, },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter.
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
