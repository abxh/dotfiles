local M = {}

M.setup = function(options, keymaps)
  local cmp = require("cmp")
  local cmp_action = require("lsp-zero").cmp_action()

  local keymaps_cmp = vim.deepcopy(keymaps.cmp)
  local keymaps_cmp_new = {}

  if keymaps_cmp.lsp_zero_cmp_actions ~= nil then
    local keymaps_cmp_special = vim.deepcopy(keymaps_cmp.lsp_zero_cmp_actions)
    keymaps_cmp.lsp_zero_cmp_actions = nil
    for _, value in pairs(keymaps_cmp_special) do
      keymaps_cmp_new[value[1]] = cmp_action[value[2]](value[3])
    end
  end

  for _, value in pairs(keymaps_cmp) do
    keymaps_cmp_new[value[1]] = cmp.mapping[value[2]](value[3])
  end

  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    sources = cmp.config.sources(unpack(options.cmp_sources)),
    mapping = cmp.mapping.preset.insert(keymaps_cmp_new),
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },

    -- borders:
    window = {
      completion = { border = "none" },
      documentation = { border = "single" },
    },

    -- lspkind:
    formatting = {
      fields = { "abbr", "kind", "menu" },
      format = require("lspkind").cmp_format({
        mode = "symbol", -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
      }),
    },

    -- disable completion in comments:
    enabled = function()
      local context = require("cmp.config.context")
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == "c" then
        return true
      else
        return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
      end
    end,

    -- ghost text:
    experimental = { ghost_text = true },
  })

  -- Use git and buffer source for `gitcommit`
  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" } }),
  })

  -- Use buffer source for `/`
  cmp.setup.cmdline("/", {
    sources = { { name = "buffer" } },
    mapping = cmp.mapping.preset.cmdline(),
  })

  -- Use cmdline & path source for ':'
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    mapping = cmp.mapping.preset.cmdline(),
  })
end

return M
