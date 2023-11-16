-- helpful global functions: {{{
function _G.put(...)
  -- inspect the contents of an object
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, "\n"))
  return ...
end

function _G.apply_keymaps(dict, opts, bind_to_module)
  if bind_to_module == nil then
    for _, value in pairs(dict) do
      vim.keymap.set(value[1], value[2], value[3], opts)
    end
  else
    local module = require(bind_to_module)
    for _, value in pairs(dict) do
      vim.keymap.set(value[1], value[2], module[value[3]], opts)
    end
  end
end

-- }}}

-- set core keybindings: {{{
local leaderkey = require("keymaps").leaderkey
vim.keymap.set("", leaderkey, "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = leaderkey
vim.g.maplocalleader = leaderkey

_G.apply_keymaps(require("keymaps").core, { silent = true })
-- }}}

-- set core options: {{{
local opts = require("options").core
local opts_append_to = opts.append_to
opts.append_to = nil

for key, value in pairs(opts) do
  vim.opt[key] = value
end
for key, value in pairs(opts_append_to) do
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
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- }}}

-- setup plugins: {{{
require("lazy").setup(unpack(require("plugins")))
-- }}}

-- vim: fdm=marker
