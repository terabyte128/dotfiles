local wezterm = require("wezterm")

local config = {
	color_scheme = "Solarized Light (Gogh)",
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

return config
