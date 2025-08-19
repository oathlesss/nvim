local now, add = MiniDeps.now, MiniDeps.add

now(function()
	add({
		source = "jglasovic/venv-lsp.nvim",
	})
	require("venv-lsp").setup()
end)
