local M = {}

M.lsp = require("plugins.lsp")
M.cmp = require("plugins.cmp")
M.integrations = require("plugins.integrations")

M.setup = function(options, keymaps)
  return {
    {
      -- auto pairs: {{{
      {
        dependencies = { "hrsh7th/nvim-cmp" },
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        init = M.integrations.autopairs_cmp,
      },
      -- }}}

      -- colorscheme: {{{
      {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = options.colorscheme,
        init = function()
          vim.cmd("colorscheme gruvbox")
        end,
      },
      -- }}}

      -- comment lines: {{{
      {
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
        },
        "numToStr/Comment.nvim",
        opts = keymaps.comment,
        config = function(_, opts)
          require("Comment").setup(vim.tbl_deep_extend("keep", opts, {
            pre_hook = M.integrations.comment_treesitter(),
          }))
        end,
        event = "VeryLazy",
      },
      -- }}}

      -- git support: {{{
      { "tpope/vim-fugitive", event = "VeryLazy" },
      {
        "lewis6991/gitsigns.nvim",
        opts = {
          signs = options.gitsigns,
          on_attach = function(bufnr)
            _G.apply_keymaps(keymaps.gitsigns, { buffer = bufnr }, "gitsigns")
            M.integrations.gitsigns_keymap(bufnr)
          end,
        },
      },
      -- }}}

      -- lsp, cmp and friends: {{{
      {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
          { "williamboman/mason.nvim", opts = {} },
          "williamboman/mason-lspconfig.nvim",
          "neovim/nvim-lspconfig",

          "hrsh7th/nvim-cmp",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-cmdline",
          "petertriho/cmp-git",
          "hrsh7th/cmp-calc",

          { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
          "rafamadriz/friendly-snippets",
          "saadparwaiz1/cmp_luasnip",

          "onsails/lspkind.nvim",
          { "ray-x/lsp_signature.nvim", event = "VeryLazy", opts = {} },

          "jay-babu/mason-null-ls.nvim",
          "nvimtools/none-ls.nvim",

          "folke/neoconf.nvim",
          "folke/neodev.nvim",

          "b0o/schemastore.nvim",
        },
        config = function()
          require("neodev").setup()
          require("neoconf").setup()
          M.lsp.setup(options, keymaps)
          M.cmp.setup(options, keymaps)
          require("mason-null-ls").setup({
            ensure_installed = vim.list_extend(options.linters, options.formatters),
            handlers = {},
          })
          require("null-ls").setup()
        end,
      },
      -- }}}

      -- surround text: {{{
      {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = { keymaps = keymaps.comment },
      },
      -- }}}

      -- telescope: {{{
      {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
          defaults = {
            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
        },
        init = function()
          _G.apply_keymaps(keymaps.telescope_builtin, {}, "telescope.builtin")
        end,
        event = "VeryLazy",
      },
      -- }}}

      -- treesitter: {{{
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = vim.tbl_deep_extend("force", options.treesitter, {
          incremental_selection = {
            keymaps = keymaps.treesitter_incremental_selection,
          },
          refactor = {
            navigation = {
              keymaps = keymaps.treesitter_navigation,
            },
          },
        }),
        config = function(_, opts)
          require("nvim-treesitter.configs").setup(opts)

          if opts.fold ~= nil and opts.fold.enable ~= nil then
            if opts.fold.enable then
              vim.opt.foldmethod = "expr"
              vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            end
          end
        end,
        dependencies = {
          "nvim-treesitter/nvim-treesitter-refactor",
          "nvim-treesitter/nvim-treesitter-textobjects",
        },
      },
      -- }}}

      -- others: {{{
      "tpope/vim-sleuth",
      { "tpope/vim-abolish", event = "VeryLazy" },
      -- }}}

      -- nonessential: {{{

      -- show html colors and etc.: {{{
      {
        "norcalli/nvim-colorizer.lua",
        priority = 0,
        config = function()
          require("colorizer").setup()
        end,
      },
      -- }}}

      -- simple tabline: {{{
      {
        "crispgm/nvim-tabline",
        opts = {
          show_index = false,
          brackets = { "", "" },
        },
        init = function()
          -- Only if there are at least two tabs (default)
          vim.opt.showtabline = 1
        end,
      },
      -- }}}

      -- pretty bar: {{{
      {
        "nvim-lualine/lualine.nvim",
        opts = {
          options = {
            theme = "gruvbox-material",
            section_separators = "",
            component_separators = "|",
          },
          sections = {
            lualine_x = { "filetype" },
          },
        },
        init = function()
          vim.opt.showmode = false
        end,
      },
      -- }}}

      -- pretty icons: {{{
      "ryanoasis/vim-devicons",
      -- }}}

      -- pretty folds: {{{
      { "anuvyklack/pretty-fold.nvim", opts = options.folds },
      -- }}}

      -- pretty indentation: {{{
      { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
      -- }}}

      -- pretty diagnostics: {{{
      {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        init = function()
          vim.diagnostic.config({ virtual_text = false, virtual_lines = false })

          if keymaps.lsp.specials ~= nil and keymaps.lsp.specials.lsp_lines_toggle ~= nil then
            local keymap = keymaps.lsp.specials.lsp_lines_toggle
            vim.keymap.set(keymap[1], keymap[2], require("lsp_lines").toggle)
          end
        end,
        opts = {},
        event = "VeryLazy",
      },
      -- }}}

      -- pretty notifications: {{{
      {
        "rcarriga/nvim-notify",
        init = function()
          vim.notify = require("notify")
        end,
      },
      -- }}}

      -- }}}
    },
    -- lazy opts: {{{
    {
      install = {
        colorscheme = { "gruvbox" },
      },
    },
    -- }}}
  }
end

return M

-- vim: fdm=marker
