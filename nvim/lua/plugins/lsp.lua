local M = {}

M.setup = function(options, keymaps)
  local lsp_signature_opts = { handler_opts = { border = "none" }, hint_enable = false }

  local keymaps_lsp = vim.deepcopy(keymaps.lsp)
  local keymaps_diagnostic = vim.deepcopy(keymaps.lsp.diagnostic)
  keymaps_lsp.diagnostic = nil
  keymaps_lsp.specials = nil

  local lsp_zero = require("lsp-zero")

  _G.apply_keymaps(keymaps_diagnostic, {}, "vim.diagnostic")
  vim.diagnostic.config({
    float = {
      header = false,
      border = 'none',
      focusable = true,
    },
  })

  lsp_zero.on_attach(function(client, bufnr)
    _G.apply_keymaps(keymaps_lsp, { buffer = bufnr }, "vim.lsp.buf")
    require("lsp_signature").on_attach(lsp_signature_opts, bufnr)
  end)
  lsp_zero.set_sign_icons({ error = "󰅚", warn = "󰀪", hint = "󰌶", info = "" })

  local servers = vim.deepcopy(options.lsps)
  require("mason-lspconfig").setup({ ensure_installed = servers, automatic_installation = { exclude = servers.manual }})

  servers = vim.list_extend(servers, servers.manual)
  servers.manual = nil
  for _, server_name in pairs(servers) do
    local specified, opts = pcall(require, "lspconfigs." .. server_name)
    if specified then
      lsp_zero.configure(server_name, opts)
    else
      lsp_zero.configure(server_name, {})
    end
  end
end

return M
