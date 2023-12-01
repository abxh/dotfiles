local linters = {}
local formatters = {
  "stylua",
  "black",
  "shfmt",
}

require("mason-null-ls").setup({
  ensure_installed = vim.list_extend(linters, formatters),
  handlers = {},
})
require("null-ls").setup()
