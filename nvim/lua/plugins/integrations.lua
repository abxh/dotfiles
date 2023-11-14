local M = {}

M.autopairs_cmp = function()
  -- to insert `(` after select function or method item
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ filetypes = { tex = false } }))
end

M.gitsigns_keymap = function(bufnr)
  -- don't override the built-in and fugitive keymaps
  local gs = package.loaded.gitsigns
  vim.keymap.set({ "n", "v" }, "]c", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
  vim.keymap.set({ "n", "v" }, "[c", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
end

M.comment_treesitter = function()
  -- calculate commentstring using treesitter.
  return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
end

return M
