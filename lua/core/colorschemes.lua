local add, now = MiniDeps.add, MiniDeps.now

now(function()
	add({ source = 'vague2k/vague.nvim' })
	add({ source = 'rose-pine/neovim' })
	add({ source = 'folke/tokyonight.nvim' })
	add({ source = 'catppuccin/nvim' })
	add({ source = 'rebelot/kanagawa.nvim' })
	add({ source = 'olimorris/onedarkpro.nvim' })
	add({ source = 'loctvl842/monokai-pro.nvim' })
	add({ source = 'water-sucks/darkrose.nvim' })

	vim.cmd('colorscheme vague')
end)
