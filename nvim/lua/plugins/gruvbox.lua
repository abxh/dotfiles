require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = false,
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
})
vim.cmd([[colorscheme gruvbox]])

local hl_overrides = {
  CursorLineNr = { fg = "#a89984", bg = "#282828" },
  SignColumn = { bg = "#282828" },
  NormalFloat = { bg = "#3a3735" },
  FloatBorder = { bg = "#3a3735" },
  DiagnosticSignError = { bg = "#282828", fg = "#ea6962" },
  DiagnosticSignWarn = { bg = "#282828", fg = "#d8a657" },
  DiagnosticSignHint = { bg = "#282828", fg = "#89b482" },
  DiagnosticSignInfo = { bg = "#282828", fg = "#7daea3" },
  TabLineFill = { bg = "#282828", fg = "#5a524c" },
  TabLineSel = { bg = "#3a3735", fg = "#a9b665" },
  TabLine = { link = "TabLineFill" },
  MiniFilesTitle = { bg = "#3a3735", fg = "#ebdbb2" },
  MiniFilesTitleFocused = { bg = "#3a3735", fg = "#ebdbb2", bold=true },
}
for key, value in pairs(hl_overrides) do
  vim.api.nvim_set_hl(0, key, value)
end
