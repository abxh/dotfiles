local M = {}

M.setup = function(options)
  require("mason-null-ls").setup({
    ensure_installed = vim.tbl_extend("keep", options.linters, options.formatters),
    handlers = {},
  })
  require("null-ls").setup()
end

return M
