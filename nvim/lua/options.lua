local M = {}

M.core = {
  -- appearance related stuff:
  wrap = false,
  number = true,
  numberwidth = 2,
  relativenumber = true,
  signcolumn = "yes",
  cursorline = true,
  fillchars = { eob = " " },

  -- don't write any backup or swap files
  writebackup = false,
  backup = false,
  swapfile = false,

  -- persistently keep undo files in /tmp/undo
  undofile = true,
  undodir = "/tmp/undo//",

  -- persistently keep view files in /tmp/view
  viewoptions = "folds,cursor,",
  viewdir = "/tmp/view//",

  -- fold everything with a maximum nesting of 4.
  -- note: this only applies at the start, if RememberFolds autocmd is enabled.
  foldlevel = 0,
  foldnestmax = 4,

  -- how many lines to look ahead when scrolling in the x-
  -- and y-direction respectively.
  scrolloff = 5,
  sidescrolloff = 5,

  -- when searching, include words with upper-case letters except in the case a
  -- upper-case letter is specified in the keyword.
  ignorecase = true,
  smartcase = true,

  -- when creating a new window, prefer splitting to the right and below.
  splitbelow = true,
  splitright = true,

  -- other functionality related stuff:
  mouse = "a",
  updatetime = 300,
  timeoutlen = 1000,
  append_to = {
    iskeyword = "-",
    whichwrap = "h,l",
  },
}

M.colorscheme = {
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,

  palette_overrides = {
    -- Gruvbox Material (Medium)
    -- This palette override thing instead of sainhe for better lsp colors.
    dark0_hard = "#1b1b1b",
    dark0 = "#282828",
    dark0_soft = "#32302f",
    dark1 = "#32302f",
    dark2 = "#3a3735",
    dark3 = "#45403d",
    dark4 = "#5a524c",

    bright_red = "#ea6962",
    bright_green = "#a9b665",
    bright_yellow = "#d8a657",
    bright_blue = "#7daea3",
    bright_purple = "#d3869b",
    bright_aqua = "#89b482",
    bright_orange = "#e78a4e",

    neutral_red = "#c14a4a",
    neutral_green = "#6c782e",
    neutral_yellow = "#b47109",
    neutral_blue = "#45707a",
    neutral_purple = "#945e80",
    neutral_aqua = "#457a5d",
    neutral_orange = "#c35e0a",

    faded_red = "#c14a4a",
    faded_green = "#6c782e",
    faded_yellow = "#b47109",
    faded_blue = "#45707a",
    faded_purple = "#945e80",
    faded_aqua = "#457a5d",
    faded_orange = "#c35e0a",

    dark_red = "#402120",
    dark_green = "#34381b",
    dark_aqua = "#0e363e",

    gray = "#7c6f64",
  },

  overrides = {
    CursorLineNr = { fg = "#a89984", bg = "#282828" },
    SignColumn = { bg = "#282828" },
    DiagnosticSignError = { bg = "#282828", fg = "#ea6962" },
    DiagnosticSignWarn = { bg = "#282828", fg = "#d8a657" },
    DiagnosticSignHint = { bg = "#282828", fg = "#89b482" },
    DiagnosticSignInfo = { bg = "#282828", fg = "#7daea3" },
    TabLineFill = { bg = "#282828" },
    TabLineSel = { bg = "#3a3735" },
    TabLine = { link = "TabLineFill" },
  },
}

M.treesitter = {
  ensure_installed = {
    -- as per the example in nvim-treesitter for the things that "should" be installed + jsonc (for neoconf files).
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "jsonc",

    -- my own reqs (for now):
    "bash",
    "python",
    "markdown",
    "haskell",
  },
  highlight = {
    enable = true,
    -- disable = { "lua", },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    navigation = {
      enable = true,
    },
  },
  context_commentstring = {
    enable = true,
  },
  fold = {
    -- using own wrapper
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
}

M.folds = {
  sections = {
    left = {
      "content",
    },
    right = {
      " ",
      "number_of_folded_lines",
      " ",
      function(config)
        return config.fill_char:rep(3)
      end,
    },
  },
  fill_char = "-",
}

M.gitsigns = {
  add = { text = "+" },
  change = { text = "~" },
  delete = { text = "_" },
  topdelete = { text = "‾" },
  changedelete = { text = "~" },
}

M.lsps = {
  "lua_ls",
  "jsonls",

  -- my own reqs (for now):
  "pyright",
  "clangd",

  manual = {
    "hls",
  }
}

M.linters = {}

M.formatters = {
  "stylua",
  "jq",
}

M.cmp_sources = {
  {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
  },
  {
    { name = "calc" },
  },
  {
    { name = "path" },
  },
  -- { { name = 'buffer' }, },
}

return M
