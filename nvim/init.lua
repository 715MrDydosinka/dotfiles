vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

require('packer').startup(function(use)
  -- Packer can manage itself
use 'wbthomason/packer.nvim'

use "hrsh7th/nvim-cmp"

use({
-- cmp LSP completion
"hrsh7th/cmp-nvim-lsp",
-- cmp Snippet completion
"hrsh7th/cmp-vsnip",
-- cmp Path completion
"hrsh7th/cmp-path",
"hrsh7th/cmp-buffer",
after = { "hrsh7th/nvim-cmp" },
requires = { "hrsh7th/nvim-cmp" },
})

use("simrat39/rust-tools.nvim")

-- LSP Config
use 'neovim/nvim-lspconfig'
end)

require('rust')

