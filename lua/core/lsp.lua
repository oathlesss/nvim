-- :h lsp-config

-- enable lsp completion
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client == nil then return end
			if client:supports_method("textDocument/completion") then
				vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
			end
    end,
})

-- disable ruff hover in favor of pyrefly hover
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttachDisableRuffHover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then return end
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "Disable ruff hover in favor of pyrefly hover",
})

-- enable configured language servers
-- you can find server configurations from lsp/*.lua files
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('pyrefly')
vim.lsp.enable('ruff')
-- vim.lsp.enable('basedpyright')

