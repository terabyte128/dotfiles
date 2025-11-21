--- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- completely disable mouse
vim.opt.mouse = ''

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

vim.g.clipboard = {
  name = 'tmux',
  copy = {
    ['+'] = { 'tmux', 'load-buffer', '-' },
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = { 'tmux', 'save-buffer', '-' },
    -- ['*'] = require('vim.ui.clipboard.osc52').paste '*',
  },
}

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.opt.smartindent = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

vim.opt.relativenumber = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- vim.diagnostic.config { virtual_text = false }
--
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Check spelling in git commits and markdown files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'enable spelling for files where it makes sense',
  group = vim.api.nvim_create_augroup('spelling', { clear = true }),
  pattern = { 'gitcommit', 'markdown', 'html' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- wrap markdown files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'wrap markdown files',
  pattern = { 'markdown' },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

require 'config.lazy'

require('appearance').watch()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

local shiftwidth = 4

vim.opt.expandtab = true -- replace tabs with spaces
vim.opt.shiftwidth = shiftwidth -- spaces for each autoindent step
vim.opt.tabstop = shiftwidth -- number of spaces that tab will insert
vim.opt.colorcolumn = '80' -- make a column at 80

if not vim.env.NOAUTOCHDIR then
  vim.opt.autochdir = true -- use local directory of file
end

local function run_cmd(cmd)
  local handle = io.popen(cmd)
  if handle then
    local result = handle:read '*a'
    handle:close()
    return (result or ''):gsub('%s+$', '') -- trim trailing whitespace
  end
  return ''
end

---@param use_default boolean
local function get_gitlab_link(use_default)
  local filepath = vim.api.nvim_buf_get_name(0) -- absolute path of current buffer
  local lineno = vim.api.nvim_win_get_cursor(0)[1] -- current line number

  local root = run_cmd 'git rev-parse --show-toplevel'
  if root == '' then
    print 'Not in a Git repo'
    return
  end

  local reponame = root:match '([^/]+)$'
  local relativepath = filepath:sub(#root + 1)

  local sha
  if use_default then
    sha = run_cmd 'git rev-parse --short origin/main'
  else
    sha = run_cmd 'git rev-parse --short HEAD'
  end

  local gitlab = string.format('https://gitlab.i.extrahop.com/core/%s/-/blob/%s%s', reponame, sha, relativepath)

  if lineno ~= 1 then
    gitlab = gitlab .. '#L' .. lineno
  end

  print(gitlab)
end

vim.api.nvim_create_user_command('Gitlab', function()
  get_gitlab_link(false)
end, {})

vim.api.nvim_create_user_command('GitlabLinkDefault', function()
  get_gitlab_link(true)
end, {})

-- wrap comments, add new comment lines automatically
-- https://neovim.io/doc/user/change.html#fo-table
vim.opt.formatoptions:append 'cro'

vim.cmd.highlight { 'link', '@diff.plus.diff', 'DiffAdd' }
vim.cmd.highlight { 'link', '@diff.minus.diff', 'DiffDelete' }
vim.cmd.highlight { 'link', '@markup.heading.gitcommit', 'Title' }

vim.api.nvim_create_user_command('KubectlApply', function()
  vim.api.nvim_command 'w'
  vim.api.nvim_command '!kubectl apply -f %'
end, { nargs = 0 })

vim.keymap.set('n', '<leader>cd', function()
  vim.diagnostic.open_float()
end, { desc = 'Show [d]iagnostics for current line' })

-- use large folds, detected by https://github.com/kevinhwang91/nvim-ufo
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

-- Function to replace checkboxes in a given range
local function replace_checkboxes_in_range()
  -- Get the current visual selection range
  local startline = vim.fn.getpos('v')[2]
  local endline = vim.fn.getpos('.')[2]

  if startline > endline then
    startline, endline = endline, startline
  end

  local pat = '%[[%s]?%]'

  -- Iterate over the lines in the visual selection
  for line_num = startline, endline do
    -- Get the current line
    local line = vim.fn.getline(line_num)
    local modified_line

    if line:match(pat) then
      modified_line = line:gsub(pat, '[x]')
    else
      modified_line = line:gsub('%[x%]', '[ ]')
    end

    -- Update the line in the buffer
    vim.fn.setline(line_num, modified_line)
  end
end

-- Command to call the function
vim.api.nvim_create_autocmd('FileType', {
  desc = 'fill in checkboxes',
  pattern = { 'markdown' },
  callback = function()
    vim.keymap.set('v', 'gC', function()
      replace_checkboxes_in_range()
    end, { desc = 'Fill in checkboxes' })
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.pkl' },
  callback = function()
    vim.bo.filetype = 'pkl'
  end,
})
