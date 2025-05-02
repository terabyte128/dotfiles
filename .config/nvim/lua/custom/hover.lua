M = {}

local ms = require('vim.lsp.protocol').Methods
local lsp = vim.lsp
local api = vim.api
local util = require 'vim.lsp.util'
local hover_ns = api.nvim_create_namespace 'nvim.lsp.hover_range'

local function client_positional_params(params)
  local win = api.nvim_get_current_win()
  return function(client)
    local ret = util.make_position_params(win, client.offset_encoding)
    if params then
      ret = vim.tbl_extend('force', ret, params)
    end
    return ret
  end
end

local file = assert(io.open(os.getenv 'HOME' .. '/.config/nvim/lua/custom/luadefinitions.json', 'r'))
local text = file:read '*a'
local definitions = vim.json.decode(text)

function M._hover(config)
  config = config or {}
  config.focus_id = ms.textDocument_hover

  lsp.buf_request_all(0, ms.textDocument_hover, client_positional_params(), function(results, ctx)
    local bufnr = assert(ctx.bufnr)
    if api.nvim_get_current_buf() ~= bufnr then
      -- Ignore result since buffer changed. This happens for slow language servers.
      return
    end

    -- Filter errors from results
    local results1 = {} --- @type table<integer,lsp.Hover>

    for client_id, resp in pairs(results) do
      local err, result = resp.err, resp.result
      if err then
        lsp.log.error(err.code, err.message)
      elseif result then
        results1[client_id] = result
      end
    end

    if vim.tbl_isempty(results1) then
      if config.silent ~= true then
        vim.notify 'No information available'
      end
      return
    end

    local contents = {} --- @type string[]

    local nresults = #vim.tbl_keys(results1)

    local format = 'markdown'

    for client_id, result in pairs(results1) do
      local client = assert(lsp.get_client_by_id(client_id))
      if nresults > 1 then
        -- Show client name if there are multiple clients
        contents[#contents + 1] = string.format('# %s', client.name)
      end
      if type(result.contents) == 'table' and result.contents.kind == 'plaintext' then
        if #results1 == 1 then
          format = 'plaintext'
          contents = vim.split(result.contents.value or '', '\n', { trimempty = true })
        else
          -- Surround plaintext with ``` to get correct formatting
          contents[#contents + 1] = '```'
          vim.list_extend(contents, vim.split(result.contents.value or '', '\n', { trimempty = true }))
          contents[#contents + 1] = '```'
        end
      else
        vim.list_extend(contents, util.convert_input_to_markdown_lines(result.contents))
        if client.name == 'clangd' then
          local s, e = string.find(result.contents.value, '`[%a%p]+`')
          local symbol = string.sub(result.contents.value, s + 1, e - 1)
          local description = definitions[symbol]

          if description ~= nil then
            contents[#contents + 1] = '---'
            contents[#contents + 1] = description
          end
        end
      end
      local range = result.range
      if range then
        local start = range.start
        local end_ = range['end']
        local start_idx = util._get_line_byte_from_position(bufnr, start, client.offset_encoding)
        local end_idx = util._get_line_byte_from_position(bufnr, end_, client.offset_encoding)

        vim.hl.range(bufnr, hover_ns, 'LspReferenceTarget', { start.line, start_idx }, { end_.line, end_idx }, { priority = vim.hl.priorities.user })
      end
      contents[#contents + 1] = '---'
    end

    -- Remove last linebreak ('---')
    contents[#contents] = nil

    if vim.tbl_isempty(contents) then
      if config.silent ~= true then
        vim.notify 'No information available'
      end
      return
    end

    local _, winid = lsp.util.open_floating_preview(contents, format, config)

    api.nvim_create_autocmd('WinClosed', {
      pattern = tostring(winid),
      once = true,
      callback = function()
        api.nvim_buf_clear_namespace(bufnr, hover_ns, 0, -1)
        return true
      end,
    })
  end)
end

function M.setup()
  lsp.buf.hover = M._hover
end

return M
