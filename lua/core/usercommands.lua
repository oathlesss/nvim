vim.api.nvim_create_user_command("DjangoDoc", function(opts)
	local query = opts.args:gsub(" ", "+")
	local url = "https://docs.djangoproject.com/en/stable/search/?q=" .. query
	-- MacOS
	if vim.fn.has("mac") == 1 then
		vim.fn.jobstart({ "open", url }, { detach = true })
		return
	end
	-- Linux
	if vim.fn.has("unix") == 1 then
		vim.fn.jobstart({ "xdg-open", url }, { detach = true })
		return
	end
end, {nargs = "+"})
