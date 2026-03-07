vim.g.mapleader = " "

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none","https://github.com/folke/lazy.nvim.git","--branch=stable",lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load options
require("config.options")

-- Load plugins
require("lazy").setup({
  unpack(require("plugins.autocomplete")),
  unpack(require("plugins.lsp")),
  unpack(require("plugins.telescope")),
  unpack(require("plugins.tree")),
  unpack(require("plugins.ui")),
  unpack(require("plugins.theme")),
})