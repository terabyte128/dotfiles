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
vim.opt.clipboard = 'unnamedplus'

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

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  { import = 'custom.plugins' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

local shiftwidth = 4
--
vim.opt.expandtab = true -- replace tabs with spaces
vim.opt.shiftwidth = shiftwidth -- spaces for each autoindent step
vim.opt.tabstop = shiftwidth -- number of spaces that tab will insert
vim.opt.colorcolumn = '80' -- make a column at 80
vim.opt.autochdir = true -- use local directory of file

vim.api.nvim_command [[
function! GitlabLink(branch)
    let filepath = expand("%:p")
    let lineno = line(".")
    let root = trim(system("git rev-parse --show-toplevel"))

    let reponame = split(root, "/")[-1]

    let filepathlen = strlen(filepath)
    let rootlen = strlen(root)

    let relativepath = strpart(filepath, rootlen, filepathlen)

    if a:branch == ""
        let sha = trim(system("git rev-parse --short HEAD"))
    elseif a:branch == "__default"
        " https://stackoverflow.com/questions/28666357/how-to-get-default-git-branch
        " to update local cache of default branch from remote:
        " git remote set-head origin -a
        let sha = split(trim(system("git rev-parse --abbrev-ref origin/HEAD")), "/")[-1]
    else
        let sha = a:branch
    endif

    let gitlab = "https://gitlab.i.extrahop.com/core/" .. reponame .. "/-/blob/" .. sha .. relativepath .. "#L" .. lineno

    echo gitlab
endfunction

]]

vim.api.nvim_command "command GitlabLink :call GitlabLink('')"
vim.api.nvim_command "command GitlabLinkDefault :call GitlabLink('__default')"

-- wrap comments, add new comment lines automatically
-- https://neovim.io/doc/user/change.html#fo-table
vim.opt.formatoptions:append 'cro'

--[[ vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.tsx', '*.ts' },
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command '%! prettier -w --parser typescript'
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.jsx', '*.js' },
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command '%! prettier -w --parser javascript'
    vim.api.nvim_win_set_cursor(0, pos)
  end,
}) ]]

vim.lsp.set_log_level 'off'

vim.api.nvim_command 'nnoremap <leader>q q'
vim.api.nvim_command 'nnoremap q <Nop>'

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { 'Dockerfile*' },
  callback = function()
    vim.api.nvim_set_option_value('filetype', 'dockerfile', {})
  end,
})
