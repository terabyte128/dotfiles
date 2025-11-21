M = {}

M.filename = os.getenv 'HOME' .. '/.config/appearance'

local function read_file(fname)
  local file, err = io.open(fname)
  if not file then
    error(err)
  end
  local content = file:read '*a'
  file:close()
  return content
end

function M.setup_colorscheme()
  local status, color = pcall(read_file, M.filename)

  if not status then
    vim.notify(color, vim.log.levels.ERROR)
    return
  end

  local last_colorscheme = vim.g.LastColorscheme

  if last_colorscheme ~= color then
    require('NeoSolarized').setup {
      style = color,
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
    vim.cmd('set background=' .. color)
  end

  vim.g.LastColorscheme = color
end

function M.watch()
  M.setup_colorscheme() -- run once at first

  local w = vim.uv.new_fs_event()

  if w == nil then
    vim.notify('failed to configure file watch, new_fs_event returned nil', vim.log.levels.ERROR)
    return
  end

  local function on_change(err, fname, status)
    M.setup_colorscheme()
  end

  w:start(
    M.filename,
    {},
    vim.schedule_wrap(function(...)
      on_change(...)
    end)
  )
end

return M
