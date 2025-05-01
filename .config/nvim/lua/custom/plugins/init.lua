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

---@param use_dark_mode boolean
local function setup_colorscheme(use_dark_mode)
  local colorscheme
  if use_dark_mode then
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
end

return {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  {
    'GeorgesAlkhouri/nvim-aider',
    cmd = 'Aider',
    -- Example key mappings for common actions:
    keys = {
      { '<leader>a/', '<cmd>Aider toggle<cr>', desc = 'Toggle Aider' },
      { '<leader>as', '<cmd>Aider send<cr>', desc = 'Send to Aider', mode = { 'n', 'v' } },
      { '<leader>ac', '<cmd>Aider command<cr>', desc = 'Aider Commands' },
      { '<leader>ab', '<cmd>Aider buffer<cr>', desc = 'Send Buffer' },
      { '<leader>a+', '<cmd>Aider add<cr>', desc = 'Add File' },
      { '<leader>a-', '<cmd>Aider drop<cr>', desc = 'Drop File' },
      { '<leader>ar', '<cmd>Aider add readonly<cr>', desc = 'Add Read-Only' },
      { '<leader>aR', '<cmd>Aider reset<cr>', desc = 'Reset Session' },
      -- Example nvim-tree.lua integration if needed
      { '<leader>a+', '<cmd>AiderTreeAddFile<cr>', desc = 'Add File from Tree to Aider', ft = 'NvimTree' },
      { '<leader>a-', '<cmd>AiderTreeDropFile<cr>', desc = 'Drop File from Tree from Aider', ft = 'NvimTree' },
    },
    dependencies = {
      'folke/snacks.nvim',
      --- The below dependencies are optional
      'catppuccin/nvim',
      'nvim-tree/nvim-tree.lua',
      --- Neo-tree integration
      'nvim-neo-tree/neo-tree.nvim',
    },
    config = function(opts)
      require('nvim_aider').setup(opts)
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module "neo-tree"
    ---@type neotree.Config?
    opts = {
      -- fill any relevant options here
    },
    config = function(opts)
      require('neo-tree').setup(opts)
      require('nvim_aider.neo_tree').setup(opts)
    end,
  },
  {
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante' },
    },
    ft = { 'markdown', 'Avante' },
  },
  {
    'f-person/auto-dark-mode.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      -- the auto-dark-mode plugin takes a bit of time to run the dark or light
      -- mode function for the first time. so just quickly read it ourselves
      -- for the initial setup to avoid annoying flashes
      local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>&1'
      if handle == nil then
        return false
      end

      local rsp = handle:read '*a'
      setup_colorscheme(rsp:find 'Dark' ~= nil)

      require('auto-dark-mode').setup {
        fallback = 'light',
        set_dark_mode = function()
          setup_colorscheme(true)
        end,
        set_light_mode = function()
          setup_colorscheme(false)
        end,
      }
    end,
  },
  {
    'mbbill/undotree',
    keys = { -- load the plugin only when using it's keybinding:
      { '<leader>u', '<cmd>UndotreeToggle<cr>' },
    },
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },
  {
    'karb94/neoscroll.nvim',
    opts = {},
  },
  {
    'tpope/vim-fugitive',
  },
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      local tree = require 'nvim-tree'
      tree.setup()

      vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeOpen<CR>')
    end,
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>cD',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'File Diagnostics',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols',
      },
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {},
  },
  {
    'ggandor/leap.nvim',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>f', '<Plug>(leap-forward)', {
        desc = 'Leap forward',
      })
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>F', '<Plug>(leap-backward)', {
        desc = 'Leap backward',
      })
      -- vim.keymap.set({ 'n', 'x', 'o' }, '<leader>gs', '<Plug>(leap-from-window)')
    end,
  },
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local lualine = require 'lualine'
      lualine.setup {
        theme = 'NeoSolarized',
        sections = {
          lualine_a = {
            'mode',
          },
          lualine_z = {},
        },
        options = {
          section_separators = '',
          component_separators = '',
        },
      }
    end,
  },
  {
    'cappyzawa/trim.nvim',
    opts = {
      ft_blocklist = { 'diff' },
    },
  },
  { 'towolf/vim-helm', ft = 'helm' },

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Plugins can also be configured to run lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', desc = '[C]ode' },
        { '<leader>d', desc = '[D]ocument' },
        { '<leader>r', desc = '[R]ename' },
        { '<leader>s', desc = '[S]earch' },
        { '<leader>t', desc = '[T]ree' },
        { '<leader>w', desc = '[W]orkspace' },
      }
    end,
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    config = function()
      local conform = require 'conform'
      local opts = {
        notify_on_error = true,
        format_on_save = {
          timeout_ms = 5000,
          lsp_fallback = true,
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          python = function(_)
            local oz = false
            local git_cmd = vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait()

            if git_cmd.stdout ~= nil then
              local basename = git_cmd.stdout:match '([^/]+)\n$'
              if basename == 'oz' then
                oz = true
              end
            end
            if oz then
              return { 'isort', 'black' }
            else
              return { 'ruff_fix', 'ruff_format' }
            end
          end,
          html = { 'prettier' },
          css = { 'prettier' },
          typescript = { 'prettier' },
          javascript = { 'prettier' },
          typescriptreact = { 'prettier' },
          javascriptreact = { 'prettier' },
          markdown = { 'prettier_markdown' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          sh = { 'shfmt' },
        },
        formatters = {
          shfmt = {
            prepend_args = { '-i', '4', '-ci', '-bn' },
          },
          black = {
            prepend_args = { '--line-length', '80' },
          },
        },
      }

      require('conform').setup(opts)

      -- https://github.com/stevearc/conform.nvim/issues/339
      local markdown_formatter = vim.deepcopy(require 'conform.formatters.prettier')
      require('conform.util').add_formatter_args(markdown_formatter, {
        '--prose-wrap',
        'always',
        '--print-width',
        '80',
      }, { append = false })
      ---@cast markdown_formatter conform.FormatterConfigOverride
      require('conform').formatters.prettier_markdown = markdown_formatter

      conform.setup(opts)
    end,
  },
  {
    -- this will be loaded by the auto-dark-mode plugin
    'Tsuzat/NeoSolarized.nvim',
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown_inline', 'vim', 'vimdoc' },
        ignore_install = { 'markdown' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },

  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_port = 12345
      -- ew, need to define a vim function so that mkdp can call it
      vim.api.nvim_exec(
        [[
        function OpenMarkdownPreview (url)
            echo a:url
        endfunction
        ]],
        {}
      )
      vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
    end,
    ft = { 'markdown' },
  },
  { import = 'custom.plugins' },
}
