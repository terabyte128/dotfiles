local wezterm = require("wezterm")

local get_appearance = function()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Light"
end

local color_scheme
local mode

if get_appearance():find("Dark") then
	color_scheme = "Solarized Dark (Gogh)"
	mode = "dark"
else
	color_scheme = "Solarized Light (Gogh)"
	mode = "light"
end

local file = io.open(os.getenv("HOME") .. "/.config/appearance", "w")

if file then
	file:write(mode)
	file:close()
end

local config = {
	color_scheme = color_scheme,
	font = wezterm.font_with_fallback({
		{
			family = "Monaspace Neon",
			weight = "Medium",
			harfbuzz_features = { "ss01", "ss02", "ss03", "ss04", "ss09", "liga" },
		},
	}),
	font_rules = {
		-- For Bold-but-not-italic text, use this relatively bold font, and override
		-- its color to a tomato-red color to make bold text really stand out.
		-- {
		-- 	italic = true,
		-- 	font = wezterm.font_with_fallback({
		-- 		{
		-- 			family = "Monaspace Radon",
		-- 			weight = "DemiBold",
		-- 		},
		-- 	}),
		-- },
	},
	-- hide_tab_bar_if_only_one_tab = true,
	window_decorations = "INTEGRATED_BUTTONS | RESIZE",
	selection_word_boundary = " \t\n{}[]()\"'`│┤:/=",
}

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

pcall(function()
	local work = require("work")
	work.add_work_rules(config)
end)

config.audible_bell = "Disabled"

return config
