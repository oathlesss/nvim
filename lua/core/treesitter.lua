local now, add = MiniDeps.now, MiniDeps.add

now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
	})
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"bash",
			"python",
			"lua",
			"vim",
			"markdown",
			"markdown_inline",
			"json",
			"yaml",
			"toml",
			"html",
			"css",
			"javascript",
			"java",
			"c",
			"cpp",
			"rust",
			"go",
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		}
	})
end)
