
return {
  -- langauge servers, linters, formatters: {{{
  { 
    'neovim/nvim-lspconfig',
    dependencies = { 
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      { "folke/neodev.nvim", config = true },
      { "folke/neoconf.nvim", config = true, cmd = "Neoconf" },

      { "ray-x/lsp_signature.nvim", opts = { handler_opts = { border = "none" }, hint_enable = false }},

      { 'mfussenegger/nvim-lint', config = function() require('lint').linters_by_ft = require('options').linters end },
      -- { 'mhartington/formatter.nvim', config = true },
    },
    init = function()
      require('mason-lspconfig').setup({
        ensure_installed = require('options').lsp_servers
      })

      local map = vim.keymap.set
      local keymaps = require('keymaps').lsp
      local lsp_buf = vim.lsp.buf

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        map('n', keymaps.goto_definition, lsp_buf.definition, bufopts)
        map('n', keymaps.goto_type_definition, lsp_buf.type_definition, bufopts)
        map('n', keymaps.goto_references, lsp_buf.references, bufopts)
        map('n', keymaps.rename, lsp_buf.rename, bufopts)

        -- map('n', '<leader>f', lsp_buf.formatting, bufopts)

        -- map('n', '<S-k>', lsp_buf.hover, bufopts)
        -- map('n', '<S-j>', lsp_buf.signature_help, bufopts)

        -- map('n', 'gi', lsp_buf.implementation, bufopts)
        -- map('n', '<leader>ca', lsp_buf.code_action, bufopts)
      end
      local lspconfig = require('lspconfig')
      for _, server in pairs(require('options').lsp_servers) do
        lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
      end
    end
  },
  -- }}}

  -- autocompletion with snippets: {{{
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'petertriho/cmp-git',
      'hrsh7th/cmp-calc',
      'onsails/lspkind.nvim',

      'hrsh7th/cmp-nvim-lua',

      { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp", },
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local keymaps = require('keymaps').cmp

      local cmp = require('cmp')
      local luasnip = require("luasnip")
      local lspkind = require('lspkind')

      local mappings = {
        nvim_lsp = '[LSP]',
        nvim_lua = '[LUA]',
        luasnip  = '[Snippet]',
        calc     = '[CALC]',
        path     = '[PATH]',
        buffer   = '[Buffer]',
      }

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- Load Snippets
      require("luasnip").config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        [keymaps.scroll_down] = cmp.mapping.scroll_docs(-4),
        [keymaps.scroll_up] = cmp.mapping.scroll_docs(4),
        [keymaps.try_complete] = cmp.mapping.complete(),
        [keymaps.abort] = cmp.mapping.abort(),
        [keymaps.confirm] = cmp.mapping.confirm({ select = false }), -- only select items explicitly
        [keymaps.hop_forward] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        [keymaps.hop_backward] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      enabled = function()
        -- disable completion in comments
        local context = require 'cmp.config.context'
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
          return true
        else
          return not context.in_treesitter_capture("comment") 
            and not context.in_syntax_group("Comment")
        end
      end,
      sources = cmp.config.sources(unpack(require('options').cmp_sources)),
      completion = { completeopt = "menu,menuone,noinsert" },
      experimental = { ghost_text = true },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol', -- show only symbol annotations
          maxwidth = 50,   -- prevent the popup from showing more than given characters.

          before = function (entry, vim_item)
            vim_item.menu = mappings[entry.source.name]
            return vim_item
          end
        })
      }
    })
    -- Use git and buffer source for `gitcommit`
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources(
        {{ name = 'cmp_git' }}, {{ name = 'buffer' }}
      )
    })
    -- Use buffer source for `/`     
    cmp.setup.cmdline('/', {
      sources = {{ name = 'buffer' }},
      mapping = cmp.mapping.preset.cmdline(),
    })
    -- Use cmdline & path source for ':' 
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources(
        {{ name = 'path' }}, {{ name = 'cmdline' }}
      ),
      mapping = cmp.mapping.preset.cmdline(),
    })
    end
  },
  -- }}}

  -- treesitter: {{{
  { 
    'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
    config = function()
      local opts = require("options").treesitter

      opts.incremental_selection.keymaps = require('keymaps').treesitter_incremental_selection
      opts.refactor.navigation.keymaps = require('keymaps').treesitter_navigation

      require('nvim-treesitter.configs').setup(opts)

      if opts.fold.enable then
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      end
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
    },
  },
  -- }}}

  -- telescope: {{{
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.4', dependencies = { 'nvim-lua/plenary.nvim' }, config = 
      function()
        local builtin = require("telescope.builtin")
        for _, value in pairs(require("keymaps").telescope_builtin) do
          vim.keymap.set(value[1], value[2], builtin[value[3]], {})
        end
      end
  },
  -- }}}

  -- auto-detect indent options: {{{
  "tpope/vim-sleuth",
  -- }}}

  -- auto pairs: {{{
  { 
    dependencies = { 'hrsh7th/nvim-cmp' },
    'windwp/nvim-autopairs', event = "InsertEnter", config = function()
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
      )
    end
  },
  -- }}}

  -- comment lines: {{{
  { 
    'numToStr/Comment.nvim', config =
    function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      })
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'JoosepAlviste/nvim-ts-context-commentstring' }
  },
  -- }}}

  -- surround text: {{{
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", config = true },
  -- }}}

  -- colorscheme: {{{
  { 
    "ellisonleao/gruvbox.nvim", priority = 1000, init = function() vim.cmd("colorscheme gruvbox") end,
    opts = require("options").colorscheme,
  },
  -- }}}

  -- git support: {{{
  "tpope/vim-fugitive",
  { "lewis6991/gitsigns.nvim", config = true },
  -- }}}

  -- nonessential: {{{

  -- pretty folds: {{{
  { 'anuvyklack/pretty-fold.nvim', opts = require("options").folds },
  -- }}}

  -- pretty indentation: {{{
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = true },
  -- }}}

  -- lsp lines: {{{
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require('lsp_lines').setup()

      local diag_config = vim.diagnostic.config
      diag_config({ virtual_text = false, virtual_lines = false,})

      local keymap = require('keymaps').lsp.lsp_lines_toggle
      vim.keymap.set('', keymap, require('lsp_lines').toggle)
    end,
  },
  -- }}}

  -- show html colors and etc.: {{{
  { "norcalli/nvim-colorizer.lua", priority = 0, config = function() require('colorizer').setup() end },
  -- }}}

  -- }}}
}

-- vim: fdm=marker
