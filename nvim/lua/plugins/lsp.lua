local M = {}

M.setup = function(options, keymaps)
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
  _G.apply_keymaps(keymaps.diagnostic, {}, "vim.diagnostic")

  local lsp_signature_opts = {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = 'single'
    },
    hint_enable = false,
  }
  local lsp_zero = require("lsp-zero")
  lsp_zero.on_attach(function(client, bufnr)
    _G.apply_keymaps(keymaps.lsp, { buffer = bufnr }, "vim.lsp.buf")
    require("lsp_signature").on_attach(lsp_signature_opts, bufnr)
  end)

  require("mason-lspconfig").setup({
    ensured_installed = { options.lsps, exclude = options.lsps_manual },
    handlers = {
      lsp_zero.default_setup,
    },
  })

  local lsp_servers = vim.list_extend(options.lsps, options.lsps_manual)
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
