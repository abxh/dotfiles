local M = {}

M.setup = function(options, keymaps)
  local lsp_signature_opts = { handler_opts = { border = "none" }, hint_enable = false }

  local keymaps = keymaps.lsp
  local keymaps_diagnostic = keymaps.diagnostic
  keymaps.diagnostic = nil
  keymaps.specials = nil

  local lsp_zero = require("lsp-zero")

  _G.apply_keymaps(keymaps_diagnostic, {}, "vim.diagnostic")

  lsp_zero.on_attach(function(client, bufnr)
    _G.apply_keymaps(keymaps, { buffer = bufnr }, "vim.lsp.buf")
    require("lsp_signature").on_attach(lsp_signature_opts, bufnr)
  end)
  lsp_zero.set_sign_icons({ error = "󰅚", warn = "󰀪", hint = "󰌶", info = "" })

  require("mason-lspconfig").setup({
    ensure_installed = options.lsps,
    handlers = { lsp_zero.default_setup },
  })
end

return M
