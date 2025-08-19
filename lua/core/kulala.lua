local later, add = MiniDeps.later, MiniDeps.add

vim.filetype.add({ extension = { ["http"] = "http", } })
later(function()
	add("mistweaverco/kulala.nvim")
	require("kulala").setup({
		display_mode = "float",
		winbar = true,
	})
end)
