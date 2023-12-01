local keymaps = require("keymaps")
local lsp_servers = {
  "lua_ls",
  "jsonls",
  "yamlls",
  "pyright",
  "clangd",
}
local lsp_servers_manual = {
  "rust_analyzer"
}
local diagnostic_opts = {
  header = false,
  border = "none",
  focusable = true,
  prefix = " ",
  close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
  source = "always",
  scope = "cursor",
}
local lsp_signature_opts = {
  bind = true,
  handler_opts = {
    border = 'single'
  },
  hint_enable = false,
}

vim.diagnostic.config({ float = diagnostic_opts })
for _, v in pairs(keymaps.diagnostic) do
  vim.keymap.set(v[1], v[2], vim.diagnostic[v[3]], {})
end

require("neodev").setup()
require("neoconf").setup()

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(_, bufnr)
  for _, v in pairs(keymaps.lsp) do
    vim.keymap.set(v[1], v[2], vim.lsp.buf[v[3]], { buffer = bufnr})
  end
  require("lsp_signature").on_attach(lsp_signature_opts, bufnr)
end)

require("mason-lspconfig").setup({
  ensured_installed = vim.list_extend(lsp_servers, lsp_servers_manual),
  handlers = {
    lsp_zero.default_setup,
  },
})

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

local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
}) -- todo: set these keybindings from keymaps.lua
