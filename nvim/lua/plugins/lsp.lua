local M = {}

M.setup = function(options, keymaps)
  local keymaps_lsp = vim.deepcopy(keymaps.lsp)
  if keymaps.lsp.specials ~= nil then
    keymaps_lsp.specials = nil
  end
  if keymaps.lsp.diagnostic ~= nil then
    local keymaps_diagnostic = vim.deepcopy(keymaps.lsp.diagnostic)
    keymaps_lsp.diagnostic = nil
    _G.apply_keymaps(keymaps_diagnostic, {}, "vim.diagnostic")
    vim.diagnostic.config({
      float = {
        header = false,
        border = "none",
        focusable = true,
      },
    })
  end
  local lsp_zero = require("lsp-zero")

  lsp_zero.set_sign_icons({ error = "󰅚", warn = "󰀪", hint = "󰌶", info = "" })

  local lsp_signature_opts = { handler_opts = { border = "none" }, hint_enable = false }
  lsp_zero.on_attach(function(client, bufnr)
    _G.apply_keymaps(keymaps_lsp, { buffer = bufnr }, "vim.lsp.buf")
    require("lsp_signature").on_attach(lsp_signature_opts, bufnr)
  end)

  local lsp_servers = vim.deepcopy(options.lsps)
  require("mason-lspconfig").setup({
    ensured_installed = { lsp_servers, exclude = lsp_servers.manual },
    handlers = {
      lsp_zero.default_setup,
    },
  })

  lsp_servers = vim.list_extend(lsp_servers, lsp_servers.manual)
  lsp_servers.manual = nil

  local lspconfig = require("lspconfig")
  for _, server_name in pairs(lsp_servers) do
    local specified, opts = pcall(require, "lspconfigs." .. server_name)
    if specified then
      lspconfig[server_name].setup(opts)
    else
      lspconfig[server_name].setup({})
    end
    lspconfig[server_name].capabilities = lsp_zero.get_capabilities()
  end
end

return M
