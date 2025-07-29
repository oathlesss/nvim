local now, add = MiniDeps.now, MiniDeps.add

now(function()
	add({
		source = "neovim/nvim-lspconfig",
	})
end)
