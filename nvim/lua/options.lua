
local M = {}

M.core = {
  -- appearance related stuff:
  wrap = false,
  number = true,
  numberwidth = 2,
  relativenumber = true,
  signcolumn = 'yes',
  cursorline = true,
  fillchars = { eob = ' ' },

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
  mouse = 'a',
  updatetime = 300,
  timeoutlen = 500,
  iskeyword = '@,48-57,_,192-255,-',
  whichwrap = '<,>,h,l',
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
  },
}

M.treesitter = {
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query",
    "bash", "python", "markdown", "jsonc",
  },
  highlight = {
    enable = true,
    disable = { 
      "lua",
    },
  },
  indent = {
    enable = true
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
}

M.folds = {
  sections = {
    left = {
       'content',
    },
    right = {
       ' ', 'number_of_folded_lines', ' ',
       function(config) return config.fill_char:rep(3) end
    }
  },
  fill_char = '-',
}

M.lsp_servers = {
  'lua_ls', 'jsonls',

  'pyright',
}

M.linters = {
  lua = { 'selene', },
  python = { 'flake8', },
}

M.formatters = {
  -- lua = { 'stylua', },
  python = { 'black', },
}

M.cmp_sources = {
  {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
  },
  {
    { name = 'calc' },
  },
  {
    { name = 'path' },
  },
  {
    { name = 'buffer' },
  },
}

return M

