---NOTE: This module is entirely AI generated. Expect bugs and missing features.
---@class ColorschemeTheme
---@field name string The display name of the theme
---@field nvim_name string|nil The Neovim colorscheme name (if available)
---@field ghostty_name string The Ghostty theme name
---@field available_in_nvim boolean Whether the theme is available in Neovim
---@field available_in_ghostty boolean Whether the theme is available in Ghostty

---@class ColorschemePickerConfig
---@field ghostty_config_path string Path to the Ghostty config file
---@field nvim_colorscheme_file string Path to the Neovim colorscheme file
---@field state_file string Path to store the current theme state

local M = {}

---@type ColorschemePickerConfig
local config = {
	ghostty_config_path = vim.fn.expand("~/.config/ghostty/config"),
	nvim_colorscheme_file = vim.fn.expand("~/personal/repos/dotfiles/nvim/lua/core/colorschemes.lua"),
	state_file = vim.fn.expand("~/.config/nvim/.colorscheme_state"),
}

---Get all available Ghostty themes
---@return string[] themes List of Ghostty theme names
local function get_ghostty_themes()
	local result = vim.system({ "ghostty", "+list-themes" }, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify("Failed to get Ghostty themes: " .. (result.stderr or ""), vim.log.levels.ERROR)
		return {}
	end

	local themes = {}
	for line in result.stdout:gmatch("[^\r\n]+") do
		-- Extract theme name and remove the (resources) or (user) suffix
		local theme_name = line:match("^(.-)%s*%(")
		if not theme_name then
			-- Fallback if no parentheses found
			theme_name = line:match("^([^%s]+)")
		end
		if theme_name and theme_name ~= "" then
			table.insert(themes, theme_name)
		end
	end
	return themes
end

---Get all available Neovim colorschemes
---@return string[] colorschemes List of Neovim colorscheme names
local function get_nvim_colorschemes()
	return vim.fn.getcompletion("", "color")
end

---Create a mapping between theme names for better matching
---@param name string Theme name to normalize
---@return string normalized Normalized theme name
local function normalize_theme_name(name)
	return name:lower():gsub("[%s%-_]", ""):gsub("%.nvim$", "")
end

---Find the best matching Neovim colorscheme for a Ghostty theme
---@param ghostty_theme string Ghostty theme name
---@param nvim_schemes string[] Available Neovim colorschemes
---@return string|nil nvim_scheme Best matching Neovim colorscheme or nil
local function find_matching_nvim_scheme(ghostty_theme, nvim_schemes)
	local normalized_ghostty = normalize_theme_name(ghostty_theme)

	-- First try exact match
	for _, scheme in ipairs(nvim_schemes) do
		if normalize_theme_name(scheme) == normalized_ghostty then
			return scheme
		end
	end

	-- Then try partial matches
	for _, scheme in ipairs(nvim_schemes) do
		local normalized_scheme = normalize_theme_name(scheme)
		if normalized_ghostty:find(normalized_scheme) or normalized_scheme:find(normalized_ghostty) then
			return scheme
		end
	end

	return nil
end

---Create unified theme list combining Ghostty and Neovim themes
---@return ColorschemeTheme[] themes List of unified themes
local function create_unified_theme_list()
	local ghostty_themes = get_ghostty_themes()
	local nvim_schemes = get_nvim_colorschemes()
	local unified_themes = {}
	local processed_nvim = {}

	-- Process Ghostty themes and find matching Neovim schemes
	for _, ghostty_theme in ipairs(ghostty_themes) do
		local matching_nvim = find_matching_nvim_scheme(ghostty_theme, nvim_schemes)

		---@type ColorschemeTheme
		local theme = {
			name = ghostty_theme,
			nvim_name = matching_nvim,
			ghostty_name = ghostty_theme,
			available_in_nvim = matching_nvim ~= nil,
			available_in_ghostty = true,
		}

		table.insert(unified_themes, theme)
		if matching_nvim then
			processed_nvim[matching_nvim] = true
		end
	end

	-- Add remaining Neovim-only themes
	for _, nvim_scheme in ipairs(nvim_schemes) do
		if not processed_nvim[nvim_scheme] then
			---@type ColorschemeTheme
			local theme = {
				name = nvim_scheme .. " (Neovim only)",
				nvim_name = nvim_scheme,
				ghostty_name = nvim_scheme, -- Fallback, won't be used
				available_in_nvim = true,
				available_in_ghostty = false,
			}
			table.insert(unified_themes, theme)
		end
	end

	-- Sort themes alphabetically
	table.sort(unified_themes, function(a, b)
		return a.name < b.name
	end)

	return unified_themes
end

---Update Ghostty config file with new theme
---@param theme_name string Ghostty theme name
---@return boolean success Whether the update was successful
local function update_ghostty_config(theme_name)
	local config_path = config.ghostty_config_path

	-- Read current config
	local file = io.open(config_path, "r")
	if not file then
		vim.notify("Could not read Ghostty config: " .. config_path, vim.log.levels.ERROR)
		return false
	end

	local content = file:read("*all")
	file:close()

	-- Update theme line
	local updated_content = content:gsub("theme%s*=%s*[^\n]*", "theme = " .. theme_name)

	-- If no theme line exists, add it at the beginning
	if not content:find("theme%s*=") then
		updated_content = "theme = " .. theme_name .. "\n" .. content
	end

	-- Write updated config
	file = io.open(config_path, "w")
	if not file then
		vim.notify("Could not write Ghostty config: " .. config_path, vim.log.levels.ERROR)
		return false
	end

	file:write(updated_content)
	file:close()

	return true
end

---Update Neovim colorscheme file
---@param scheme_name string Neovim colorscheme name
---@return boolean success Whether the update was successful
local function update_nvim_colorscheme_file(scheme_name)
	local file_path = config.nvim_colorscheme_file

	-- Read current file
	local file = io.open(file_path, "r")
	if not file then
		vim.notify("Could not read Neovim colorscheme file: " .. file_path, vim.log.levels.ERROR)
		return false
	end

	local content = file:read("*all")
	file:close()

	-- Update colorscheme line
	local updated_content = content:gsub("vim%.cmd%('colorscheme [^']*'%)", "vim.cmd('colorscheme " .. scheme_name .. "')")

	-- Write updated file
	file = io.open(file_path, "w")
	if not file then
		vim.notify("Could not write Neovim colorscheme file: " .. file_path, vim.log.levels.ERROR)
		return false
	end

	file:write(updated_content)
	file:close()

	return true
end

---Save current theme state
---@param theme ColorschemeTheme Current theme
local function save_theme_state(theme)
	local file = io.open(config.state_file, "w")
	if file then
		file:write(vim.json.encode(theme))
		file:close()
	end
end

---Apply a theme to both Neovim and Ghostty
---@param theme ColorschemeTheme Theme to apply
---@return boolean success Whether the theme was applied successfully
local function apply_theme(theme)
	local success = true

	-- Apply Neovim colorscheme if available
	if theme.available_in_nvim and theme.nvim_name then
		local ok = pcall(vim.cmd.colorscheme, theme.nvim_name)
		if not ok then
			vim.notify("Failed to apply Neovim colorscheme: " .. theme.nvim_name, vim.log.levels.WARN)
			success = false
		else
			-- Update the colorscheme file for persistence
			local update_ok = pcall(update_nvim_colorscheme_file, theme.nvim_name)
			if not update_ok then
				vim.notify("Failed to update Neovim colorscheme file", vim.log.levels.WARN)
			end
		end
	end

	-- Apply Ghostty theme if available (but don't crash if it fails)
	if theme.available_in_ghostty then
		local update_ok = pcall(update_ghostty_config, theme.ghostty_name)
		if update_ok then
			-- Simple notification - manual reload required
			vim.notify("Ghostty config updated to: " .. theme.ghostty_name .. "\nPress Cmd+Shift+, in Ghostty to reload", vim.log.levels.INFO)
		else
			vim.notify("Failed to update Ghostty config", vim.log.levels.WARN)
		end
	end

	-- Save current state (only if at least Neovim theme worked)
	if theme.available_in_nvim then
		local save_ok = pcall(save_theme_state, theme)
		if not save_ok then
			vim.notify("Failed to save theme state", vim.log.levels.WARN)
		end
	end

	return success
end

---Create theme display string for picker
---@param theme ColorschemeTheme Theme to display
---@return string display Display string for the theme
local function create_theme_display(theme)
	local indicators = {}

	if theme.available_in_nvim then
		table.insert(indicators, "N")
	end

	if theme.available_in_ghostty then
		table.insert(indicators, "G")
	end

	local indicator_str = "[" .. table.concat(indicators, ",") .. "]"
	return string.format("%-40s %s", theme.name, indicator_str)
end

---Show colorscheme picker with live preview
function M.pick_colorscheme()
	local themes = create_unified_theme_list()
	local initial_scheme = vim.g.colors_name

	if #themes == 0 then
		vim.notify("No themes available", vim.log.levels.WARN)
		return
	end

	-- Create simple string items for the picker (like the original)
	local theme_names = {}
	local theme_lookup = {}

	for _, theme in ipairs(themes) do
		local display_name = create_theme_display(theme)
		table.insert(theme_names, display_name)
		theme_lookup[display_name] = theme
	end

	-- Use the same pattern as your original colorscheme picker
	local result = require('mini.pick').start({
		source = {
			items = theme_names,
			name = "Colorschemes",
			preview = function(buf_id, item_name)
				local theme = theme_lookup[item_name]
				if theme and theme.available_in_nvim and theme.nvim_name then
					pcall(vim.cmd.colorscheme, theme.nvim_name)
				end

				-- Show theme info in preview buffer
				if theme then
					local lines = {
						"Theme: " .. theme.name,
						"",
						"Available in:",
						"  Neovim: " .. (theme.available_in_nvim and "✓" or "✗"),
						"  Ghostty: " .. (theme.available_in_ghostty and "✓" or "✗"),
						"",
					}

					if theme.nvim_name then
						table.insert(lines, "Neovim scheme: " .. theme.nvim_name)
					end

					table.insert(lines, "Ghostty theme: " .. theme.ghostty_name)

					vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
					vim.api.nvim_buf_set_option(buf_id, "filetype", "text")
				end
			end,
			choose = function(item_name)
				local theme = theme_lookup[item_name]
				if theme then
					apply_theme(theme)
					vim.notify("Applied theme: " .. theme.name)
				end
			end,
		},
	})

	-- If picker was cancelled, restore initial theme
	if not result then
		if initial_scheme then
			pcall(vim.cmd.colorscheme, initial_scheme)
		end
	end
end

---Initialize the colorscheme picker
function M.setup()
	-- Create state directory if it doesn't exist
	local state_dir = vim.fn.fnamemodify(config.state_file, ":h")
	vim.fn.mkdir(state_dir, "p")

	-- Verify Ghostty is available
	local ghostty_available = vim.fn.executable("ghostty") == 1
	if not ghostty_available then
		vim.notify("Ghostty not found in PATH. Colorscheme picker will work for Neovim only.", vim.log.levels.WARN)
		return
	end

	-- DON'T apply theme on startup to avoid crashing Ghostty
	-- The theme will be applied when user manually selects one
	-- This prevents startup crashes
end

return M
