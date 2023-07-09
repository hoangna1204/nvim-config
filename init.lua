-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false


-- ========================================================================== --
-- ==                             KEYBINDINGS                              == --
-- ========================================================================== --

-- Space as leader key
vim.g.mapleader = ' '

-- Shortcuts
vim.keymap.set({'n', 'x', 'o'}, '<leader>h', '^')
vim.keymap.set({'n', 'x', 'o'}, '<leader>l', 'g_')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'gy', '"+y') -- copy
vim.keymap.set({'n', 'x'}, 'gp', '"+p') -- paste

-- Delete text
vim.keymap.set({'n', 'x'}, 'x', '"_x')

-- Commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>bq', '<cmd>bdelete<cr>')
vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<cr>')


-- ========================================================================== --
-- ==                               COMMANDS                               == --
-- ========================================================================== --

vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})

local group = vim.api.nvim_create_augroup('user_cmds', {clear = true})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = group,
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 200})
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help', 'man'},
  group = group,
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})


-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
  { 'folke/tokyonight.nvim' },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
	{ 'folke/which-key.nvim'},
	{ 'akinsho/bufferline.nvim', dependencies = {'nvim-tree/nvim-web-devicons'} },
	{ 'phaazon/hop.nvim', lazy = true },
	{ 'nvim-tree/nvim-tree.lua', lazy = true, dependencies = {
    'nvim-tree/nvim-web-devicons',
		},
  },
	{ 'nvim-telescope/telescope.nvim', lazy = true, dependencies = {
    'nvim-lua/plenary.nvim',
    }
  },
	{ 'goolord/alpha-nvim', lazy = true },
	{ 'nvim-treesitter/nvim-treesitter' },
	-- Language Support
  {
    'VonHeikemen/lsp-zero.nvim',
    lazy = true,
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
    	{'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional
      {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    }
  },
	{ 'windwp/nvim-autopairs' },
	{ 'kylechui/nvim-surround', config = function()
    require("nvim-surround").setup({
  	 -- Configuration here, or leave empty to use defaults
    })
    end
  },
	{ 'jiaoshijie/undotree', dependencies  = {
		'nvim-lua/plenary.nvim',
    },
  },
	{ 'lukas-reineke/indent-blankline.nvim' },
  { 'HiPhish/nvim-ts-rainbow2' },
	{ 'lewis6991/gitsigns.nvim' },
	{ 'sindrets/diffview.nvim' },
	{
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = ":call mkdp#util#install()",
  },
})


-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- Colorscheme
---
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

---
-- Bufferline
---

require("bufferline").setup{
	options = {
    hover = {
      enabled = true,
      delay = 150,
      reveal = {'close'}
    }
  }
}


---
-- lualine.nvim (statusline)
---
vim.opt.showmode = false
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'tokyonight',
    component_separators = '|',
    section_separators = '',
  },
})

---
-- Markdown preview
---
vim.g.mkdp_browser = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
vim.g.mkdp_auto_start = 1
--vim.g.mkdp_auto_close = 1
--vim.g.mkdp_refresh_slow = 1
--vim.g.mkdp_command_for_global = 0
--vim.g.mkdp_open_to_the_world = 0
--vim.g.mkdp_open_ip = '127.0.0.1'
--vim.g.mkdp_echo_preview_url = 0
--vim.g.mkdp_browserfunc = ''
--vim.g.mkdp_markdown_css = ''
--vim.g.mkdp_hightlight_css = ''
--vim.g.mkdp_port = '8888'
--vim.g.mkdp_page_title = ' [${name}] '


require 'whichkey'
require 'hop-config'
require 'nvim-tree-config'
require 'telescope-config'
require 'alpha-config'
require 'treesitter-config'
require 'autopairs-config'
require 'undotree-config'
require 'indentline-config'
require 'git-config'
require 'lsp-config'
