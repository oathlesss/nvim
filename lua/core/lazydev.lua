local now, add = MiniDeps.now, MiniDeps.add

now(function()
	add({ source = "folke/lazydev.nvim" })
	require("lazydev").setup({
		library = {
			{ path = "${3rd}/luv/libary", words = { "vim%.uv" } },
		},
	})
end)
