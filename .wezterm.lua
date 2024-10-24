local wezterm = require("wezterm")

local config = {
	color_scheme = "Solarized Light (Gogh)",
	font = wezterm.font({
		family = "Monaspace Neon",
		weight = "Medium",
		harfbuzz_features = { "ss01", "ss02", "ss04", "ss09", "liga" },
	}),
	-- font_size = 12.2,
	hide_tab_bar_if_only_one_tab = true,
	-- term = "wezterm",
	-- freetype_load_target = "Light",
}

return config
