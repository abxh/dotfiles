local M = {}

M.setup = function(options)
  require("mason-null-ls").setup({
    ensure_installed = vim.list_extend(options.linters, options.formatters),
    handlers = {},
  })
  require("null-ls").setup()
end

return M
