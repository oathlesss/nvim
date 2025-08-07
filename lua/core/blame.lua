local later, add = MiniDeps.later, MiniDeps.add

later(function()
	add({
		source = "FabijanZulj/blame.nvim",
	})
	require("blame").setup({})
end)
