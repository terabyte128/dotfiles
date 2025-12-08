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

return {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

  -- {
  --   name = 'clangd-lua-docs',
  --   dir = '~/Code/neovim-plugins/clangd-lua-docs/',
  --   config = true,
  -- },
  { 'google/vim-jsonnet' },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { '<leader>tt', '<cmd>Oil<cr>', desc = 'NeoTree' },
    },
  },
  {
    'terabyte128/clangd-lua-docs',
    config = true,
  },
  {
    'nmac427/guess-indent.nvim',
    opts = {},
  },
  -- {
  --   'nvim-neo-tree/neo-tree.nvim',
  --   branch = 'v3.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  --     'MunifTanjim/nui.nvim',
  --     -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  --   },
  --   lazy = false, -- neo-tree will lazily load itself
  --   ---@module "neo-tree"
  --   ---@type neotree.Config?
  --   opts = {
  --     filesystem = {
  --       bind_to_cwd = false,
  --     },
  --     -- fill any relevant options here
  --   },
  --   keys = {
  --     { '<leader>tt', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' },
  --   },
  -- },
  {
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante' },
    },
    ft = { 'markdown', 'Avante' },
  },
  {
    'mbbill/undotree',
    keys = { -- load the plugin only when using it's keybinding:
      { '<leader>u', '<cmd>UndotreeToggle<cr>' },
    },
  },
  {
    'karb94/neoscroll.nvim',
    opts = {},
  },
  {
    'tpope/vim-fugitive',
  },
  {
    'shumphrey/fugitive-gitlab.vim',
  },
  {
    'tpope/vim-rhubarb',
  },
  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   config = function()
  --     local tree = require 'nvim-tree'
  --     tree.setup()
  --
  --     vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeOpen<CR>')
  --   end,
  -- },
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
        format_on_save = function(bufnr)
          local git_cmd = vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait()
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if (git_cmd.stdout:match 'sensor' and not bufname:match '.lua') or bufname:match 'slide' then
            return {
              formatters = { 'sensor_formatter' },
            }
          end

          return {
            timeout_ms = 5000,
            lsp_fallback = true,
          }
        end,
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
          typescript = { 'prettier', 'eslint_d' },
          javascript = { 'prettier', 'eslint_d' },
          typescriptreact = { 'prettier', 'eslint_d' },
          javascriptreact = { 'prettier', 'eslint_d' },
          markdown = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          sh = { 'shfmt' },
          jsonnet = { 'jsonnetfmt' },
          go = { 'golangci-lint' },
          pkl = { 'pkl-format' },
        },
        formatters = {
          jsonnetfmt = {
            command = 'jsonnetfmt',
          },
          shfmt = {
            prepend_args = { '-i', '4', '-ci', '-bn' },
          },
          black = {
            prepend_args = { '--line-length', '80' },
          },
          sensor_formatter = {
            command = vim.fn.expand '$HOME/src/sensor/build/tools/format_code.sh',
            args = { '-f', '$FILENAME' },
          },
          ['pkl-format'] = {
            stdin = false,
            command = 'pkl',
            args = { 'format', 'apply', '$FILENAME' },
          },
        },
      }

      require('conform').setup(opts)

      -- -- https://github.com/stevearc/conform.nvim/issues/339
      -- local markdown_formatter = vim.deepcopy(require 'conform.formatters.prettier')
      -- require('conform.util').add_formatter_args(markdown_formatter, {
      --   '--prose-wrap',
      --   'always',
      --   '--print-width',
      --   '80',
      -- }, { append = false })
      -- ---@cast markdown_formatter conform.FormatterConfigOverride
      -- require('conform').formatters.prettier_markdown = markdown_formatter

      conform.setup(opts)
    end,
  },
  {
    'Tsuzat/NeoSolarized.nvim',
    priority = 1000,
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
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
    lazy = false,
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown_inline', 'vim', 'vimdoc' },
      ignore_install = { 'markdown' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      folds = { enable = true },
    },
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
}
