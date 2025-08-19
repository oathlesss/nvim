local now, add = MiniDeps.now, MiniDeps.add

now(function()
	add({
		source = "ibhagwan/fzf-lua",
		depends = { "echasnovski/mini.icons", },
	})
	require("fzf-lua").setup()
end)
