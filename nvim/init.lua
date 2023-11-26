-- set global functions: {{{
_G.put = vim.print
_G.apply_keymaps = function(dict, opts, bind_to_module)
  if bind_to_module == nil then
    for _, v in pairs(dict) do
      vim.keymap.set(v[1], v[2], v[3], opts)
    end
  else
    local m = require(bind_to_module)
    for _, v in pairs(dict) do
      vim.keymap.set(v[1], v[2], m[v[3]], opts)
    end
  end
end
-- }}}

local options = require("options")
local keymaps = require("keymaps")
require("autocmds")
vim.cmd("source " .. vim.fn.stdpath("config") .. "/lua/autocmds.vim")

-- set core keybindings: {{{
local opts = { noremap = true, silent = true }
if keymaps.leaderkey ~= nil then
  vim.keymap.set("", keymaps.leaderkey, "<Nop>", opts)
  vim.g.mapleader = keymaps.leaderkey
  vim.g.maplocalleader = keymaps.leaderkey
end
_G.apply_keymaps(keymaps.core, opts)
-- }}}

-- set core options: {{{
for key, value in pairs(options.core) do
  vim.opt[key] = value
end
for key, value in pairs(options.core_append_to) do
  vim.opt[key]:append(value)
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
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- }}}

-- setup plugins: {{{
require("lazy").setup(unpack(require("plugins").setup(options, keymaps)))
-- }}}

-- vim: fdm=marker
