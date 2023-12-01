require("autocmds")
vim.cmd("source " .. vim.fn.stdpath("config") .. "/lua/autocmds.vim")

-- set core options: {{{
local o = vim.opt

o.wrap = false
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.fillchars = { eob = " " }
o.splitbelow = true
o.splitright = true
o.showtabline = 1
o.scrolloff = 5
o.sidescrolloff = 5

o.writebackup = false
o.backup = false
o.swapfile = false
o.undofile = true
o.undodir = "/tmp/undo//"
o.viewoptions = "folds,cursor,"
o.viewdir = "/tmp/view//"

o.ignorecase = true
o.smartcase = true

o.iskeyword:append("-")
o.whichwrap:append("h,l")
-- }}}

local keymaps = require("keymaps")
local opts = { noremap = true, silent = true }
if keymaps.leaderkey ~= nil then
  vim.keymap.set("", keymaps.leaderkey, "<Nop>", opts)
  vim.g.mapleader = keymaps.leaderkey
  vim.g.maplocalleader = keymaps.leaderkey
end
for _, value in pairs(keymaps.core) do
  vim.keymap.set(unpack(vim.list_extend(value, opts)))
end

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
require("lazy").setup(unpack(require("plugins")))

-- vim: fdm=marker
