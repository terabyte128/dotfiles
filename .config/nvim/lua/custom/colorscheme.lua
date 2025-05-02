M = {}

function M.setup_colorscheme()
  -- the auto-dark-mode plugin takes a bit of time to run the dark or light
  -- mode function for the first time. so just quickly read it ourselves
  -- for the initial setup to avoid annoying flashes
  local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>&1'
  if handle == nil then
    return false
  end

  local rsp = handle:read '*a'

  local colorscheme
  if rsp:find 'Dark' ~= nil then
    colorscheme = 'dark'
  else
    colorscheme = 'light'
  end

  require('NeoSolarized').setup {
    style = colorscheme,
    transparent = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      functions = { bold = true },
      variables = {},
      string = { italic = false },
    },
  }
  vim.cmd 'colorscheme NeoSolarized'
  vim.cmd('set background=' .. colorscheme)
end

return M
