require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

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

  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua

  require 'custom/plugins/gitsigns',
  require 'custom/plugins/which-key',
  require 'custom/plugins/telescope',
  require 'custom/plugins/lspconfig',
  require 'custom/plugins/conform',
  require 'custom/plugins/cmp',
  require 'custom/plugins/tokyonight',
  require 'custom/plugins/todo-comments',
  require 'custom/plugins/mini',
  require 'custom/plugins/treesitter',
  require 'custom/plugins/debug',
  require 'custom/plugins/indent_line',
  require 'custom/plugins/lint',
  require 'custom/plugins/autopairs',
  require 'custom/plugins/neo-tree',
  require 'custom/plugins/wakatime',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
