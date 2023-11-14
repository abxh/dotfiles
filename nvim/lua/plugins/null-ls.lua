local M = {}

M.setup = function()
  require("mason-null-ls").setup({
    ensure_installed = vim.tbl_extend("keep", require("options").linters, require("options").formatters),
    handlers = {},
  })
  require("null-ls").setup()
end

return M
