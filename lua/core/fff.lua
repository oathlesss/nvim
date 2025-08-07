local now, add = MiniDeps.now, MiniDeps.add

now(function()
	add({
		source = "dmtrKovalenko/fff.nvim",
	})
	require("fff").setup()
end)
