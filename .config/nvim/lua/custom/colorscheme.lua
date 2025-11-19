M = {}

function M.setup_colorscheme()
  -- the auto-dark-mode plugin takes a bit of time to run the dark or light
  -- mode function for the first time. so just quickly read it ourselves
  -- for the initial setup to avoid annoying flashes
  local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>&1'
  local rsp = 'light'

  if handle == nil then
    rsp = os.getenv 'COLORSCHEME' or rsp
  else
    rsp = handle:read '*a'
    if rsp:lower():find 'not found' then
      rsp = os.getenv 'COLORSCHEME' or rsp
    end
  end

  local colorscheme
  if rsp:lower():find 'dark' ~= nil then
    colorscheme = 'dark'
  else
    colorscheme = 'light'
  end

  last_colorscheme = vim.g.LastColorscheme

  if last_colorscheme ~= colorscheme then
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

  vim.g.LastColorscheme = colorscheme
end

return M
