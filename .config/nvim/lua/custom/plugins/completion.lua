function Log(data)
  local file = io.open('/tmp/nvim.log', 'a')

  if file then
    -- Write content to the file
    file:write(data .. '\n')
    -- Close the file
    file:close()
  else
    print 'Error opening the file for writing'
  end
end

return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'rafamadriz/friendly-snippets',
      -- {
      --   'zbirenbaum/copilot.lua',
      --   opts = {
      --     -- suggestion panels are provided by nvim-cmp
      --     suggestion = { enabled = false },
      --     panel = { enabled = false },
      --   },
      -- },
      -- { 'zbirenbaum/copilot-cmp', opts = {} },
      'ray-x/cmp-treesitter',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local compare = require 'cmp.config.compare'

      luasnip.config.setup {}

      -- load snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      local function deprioritize_copilot(a, b)
        -- return true if a < b

        if a.copilot and not b.copilot then
          return true
        else
          return false
        end
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },

        sources = {
          { name = 'lazydev' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
          { name = 'treesitter' },
          { name = 'buffer' },
          { name = 'copilot' },
          { name = 'luasnip' },
          { name = 'path' },
        },
        -- sorting = {
        --   priority_weight = 2,
        --   comparators = {
        --     deprioritize_copilot,
        --     compare.offset,
        --     compare.exact,
        --     -- compare.scopes,
        --     compare.score,
        --     compare.recently_used,
        --     compare.locality,
        --     compare.kind,
        --     -- compare.sort_text,
        --     compare.length,
        --     compare.order,
        --   },
        -- },
      }
    end,
  },
}
