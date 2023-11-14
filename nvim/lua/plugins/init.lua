return {
  {
    -- auto pairs: {{{
    {
      dependencies = { "hrsh7th/nvim-cmp" },
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      init = require("plugins.integrations").autopairs_cmp,
    },
    -- }}}

    -- colorscheme: {{{
    {
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
      opts = require("options").colorscheme,
      init = function()
        vim.cmd("colorscheme gruvbox")
      end,
    },
    -- }}}

    -- comment lines: {{{
    {
      dependencies = { "nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring" },
      "numToStr/Comment.nvim",
      opts = require("keymaps").comment,
      config = function(_, opts)
        require("Comment").setup(vim.tbl_extend("keep", opts, {
          pre_hook = require("plugins.integrations").comment_treesitter(),
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
        signs = require("options").gitsigns,
        on_attach = function(bufnr)
          apply_keymaps(require("keymaps").gitsigns, { buffer = bufnr }, "gitsigns")
          require("plugins.integrations").gitsigns_keymap(bufnr)
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
      },
      config = function()
        require("neoconf").setup()
        require("plugins.lsp").setup()
        require("plugins.cmp").setup()
        require("plugins.null-ls").setup()
      end,
    },
    -- }}}

    -- surround text: {{{
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      opts = { keymaps = require("keymaps").comment },
    },
    -- }}}

    -- telescope: {{{
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.4",
      dependencies = { "nvim-lua/plenary.nvim" },
      init = function()
        apply_keymaps(require("keymaps").telescope_builtin, {}, "telescope.builtin")
      end,
      event = "VeryLazy",
    },
    -- }}}

    -- treesitter: {{{
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      opts = vim.tbl_extend("keep", require("options").treesitter, {
        incremental_selection = {
          keymaps = require("keymaps").treesitter_incremental_selection,
        },
        refactor = {
          navigation = {
            keymaps = require("keymaps").treesitter_navigation,
          },
        },
      }),
      config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)

        if opts.fold.enable then
          vim.opt.foldmethod = "expr"
          vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
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
    { "anuvyklack/pretty-fold.nvim", opts = require("options").folds },
    -- }}}

    -- pretty indentation: {{{
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    -- }}}

    -- pretty diagnostics: {{{
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      init = function()
        vim.diagnostic.config({ virtual_text = false, virtual_lines = false })

        local keymap = require("keymaps").lsp.special.lsp_lines_toggle
        vim.keymap.set(keymap[1], keymap[2], require("lsp_lines").toggle)
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

-- vim: fdm=marker
