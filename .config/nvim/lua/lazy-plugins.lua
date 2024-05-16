require('lazy').setup({
  'tpope/vim-sleuth', 
  
  { 'numToStr/Comment.nvim', opts = {} },

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
  require 'custom/plugins/alpha-nvim'
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
