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
local keymap_options = { noremap = true, silent = true }

if keymaps.core.leaderkey ~= nil then
  local leaderkey = keymaps.core.leaderkey
  vim.keymap.set("", leaderkey, "<Nop>", keymap_options)
  vim.g.mapleader = leaderkey
  vim.g.maplocalleader = leaderkey
  keymaps.core.leaderkey = nil
end

_G.apply_keymaps(keymaps.core, keymap_options)
-- }}}

-- set core options: {{{
local core_options = options.core
if core_options.append_to ~= nil then
  local opts_append_to = core_options.append_to
  for key, value in pairs(opts_append_to) do
    vim.opt[key]:append(value)
  end
  core_options.append_to = nil
end

for key, value in pairs(core_options) do
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
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- }}}

-- setup plugins: {{{
require("lazy").setup(unpack(require("plugins").setup(require("options"), require("keymaps"))))
-- }}}

-- vim: fdm=marker
