local M = {}

M.setup = function(options, keymaps)
  local keymaps_lsp = vim.deepcopy(keymaps.lsp)
  if keymaps.lsp.specials ~= nil then
    keymaps_lsp.specials = nil
  end

  local diagnostic_opts = {
    header = false,
    border = "none",
    focusable = true,
    prefix = " ",
    close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
    source = "always",
    scope = "cursor",
  }
  vim.diagnostic.config({ float = diagnostic_opts })
  if keymaps.lsp.diagnostic ~= nil then
    local keymaps_diagnostic = vim.deepcopy(keymaps.lsp.diagnostic)
    keymaps_lsp.diagnostic = nil
    _G.apply_keymaps(keymaps_diagnostic, {}, "vim.diagnostic")
  end

  local lsp_signature_opts = {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = 'single'
    },
    hint_enable = false,
  }
  local lsp_zero = require("lsp-zero")
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
  lsp_zero.set_sign_icons({ error = "󰅚", warn = "󰀪", hint = "󰌶", info = "" })
end

return M
