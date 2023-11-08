
-- set core keybindings: {{{
local opts = { noremap = true, silent = true }
local map = vim.keymap.set

local leaderkey = require('keymaps').leaderkey
map('', leaderkey, '<Nop>', opts)
vim.g.mapleader = leaderkey
vim.g.maplocalleader = leaderkey

for _, value in pairs(require('keymaps').core) do
  map(value[1], value[2], value[3], opts)
end
-- }}}

-- set core options: {{{
for key, value in pairs(require('options').core) do
  vim.opt[key] = value
end
-- }}}

-- bootstrap plugin manager {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- }}}

-- setup plugins: {{{
require('lazy').setup(require('plugins'))
-- }}}

-- vim: fdm=marker
