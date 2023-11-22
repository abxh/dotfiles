
-- note: 
-- will only check for nil value after the first level of the dictionaries.
-- that is that the top level dictionary must be defined (it must at least be empty).
-- exception: coerce dict which is not used by anything.

local M = {}

M.core = {
  leaderkey = ",",

  -- cancel search with <Esc>
  { "n", "<Esc>", ":noh<CR>" },

  -- stay in indent mode
  { "v", "<", "<gv^" },
  { "v", ">", ">gv^" },

  -- access global clipboard with Ctrl + {c,x,v}
  { "v", "<C-c>", '"+y' },
  { "v", "<C-x>", '"+c<Esc>' },
  { "n", "<C-v>", '"+p' },
  { "v", "<C-v>", 'c<Esc>"+p' },
  { "i", "<C-v>", "<C-r><C-o>+" },

  -- windows split / close
  { "n", "<A-v>", ":vsplit<CR>"},
  { "n", "<A-b>", ":split<CR>"},
  { "n", "<A-q>", ":q<CR>"},

  -- window navigation
  { "n", "<A-k>", "<C-w>k" },
  { "n", "<A-j>", "<C-w>j" },
  { "n", "<A-h>", "<C-w>h" },
  { "n", "<A-l>", "<C-w>l" },

  -- window resize
  { "n", "<A-S-k>", ":resize +2<CR>" },
  { "n", "<A-S-j>", ":resize -2<CR>" },
  { "n", "<A-S-h>", ":vertical resize -2<CR>" },
  { "n", "<A-S-l>", ":vertical resize +2<CR>" },

  -- tab navigation
  { "n", "<A-,>", "gT" },
  { "n", "<A-.>", "gt" },
  { "n", "<A-Enter>", ":tabnew<CR>" },
  { "n", "<A-S-q>", ":tabclose<CR>" },
}

M.treesitter_incremental_selection = {
  init_selection = "<S-l>",
  node_incremental = "<S-l>",
  -- scope_incremental = "grc",
  node_decremental = "<S-h>",
}

M.treesitter_navigation = {
  -- goto_definition = "gnd",
  -- list_definitions = "gnD",
  -- list_definitions_toc = "gO",
  goto_next_usage = "gnn",
  goto_previous_usage = "gnN",
}

M.telescope_builtin = {
  { "n", "<leader>ff", "find_files" },
  { "n", "<leader>fg", "live_grep" },
  { "n", "<leader>fb", "buffers" },
  { "n", "<leader>fh", "help_tags" },
  { "n", "<leader>gf", "git_files" },
}

M.gitsigns = {
  { "n", "<leader>hp", "preview_hunk" },
}

M.lsp = {
  specials = {
    lsp_lines_toggle = { "n", "<leader>l" },
  },

  { "n", "gd", "definition" },
  { "n", "gD", "declaration" },
  { "n", "gi", "implementation" },
  { "n", "go", "type_definition" },

  { "n", "gr", "references" },
  { "n", "<C-h>", "signature_help" },
  { "n", "<F2>", "rename" },
  { "n", "<F3>", "format" },
  { "n", "<F4>", "code_action" },

  diagnostic = {
    { "n", "K", "open_float" },
    -- use q to get out of float.
    { "n", "[d", "goto_prev" },
    { "n", "]d", "goto_next" },
  },
}

M.cmp = {
  lsp_zero_cmp_actions = {
    { "<Tab>", "luasnip_supertab", nil },
    { "<S-Tab>", "luasnip_shift_supertab", nil },
  },

  -- `Enter` key to confirm completion
  { "<CR>", "confirm", { select = false } },

  -- Ctrl+Space to trigger completion menu
  { "<C-Space>", "complete", nil },

  -- Ctrl+e to abort completion. Useful while supertabbing.
  { "<C-e>", "abort", nil },

  -- Scroll up and down in the completion documentation
  { "<PageUp>", "scroll_docs", -4 },
  { "<PageDown>", "scroll_docs", 4 },
}

M.comment = {
  ---LHS of toggle mappings in NORMAL mode
  toggler = {
    ---Line-comment toggle keymap
    line = "gcc",
    ---Block-comment toggle keymap
    block = "gbc",
  },
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  opleader = {
    ---Line-comment keymap
    line = "gc",
    ---Block-comment keymap
    block = "gb",
  },
  ---LHS of extra mappings
  extra = {
    ---Add comment on the line above
    above = "gcO",
    ---Add comment on the line below
    below = "gco",
    ---Add comment at the end of line
    eol = "gcA",
  },
}

M.surround = {
  insert = "<C-g>s",
  insert_line = "<C-g>S",
  normal = "ys",
  normal_cur = "yss",
  normal_line = "yS",
  normal_cur_line = "ySS",
  visual = "S",
  visual_line = "gS",
  delete = "ds",
  change = "cs",
  change_line = "cS",
}

M.coerce = {
  -- this dictionary is not used for anything. Is a helpful note for vim-abolish.
  -- note: I created this as i could not find a easy way to redefine the vim-abolish keybinds.

  -- cr stands for coerce.

  -- change naming variant by typing in normal mode:
  -- cr +
  -- s : snake_case
  -- m : MixedCase
  -- c : camelCase
  -- u : UPPER_CASE
  -- - : dash-case
  -- . : dot.case
}

return M
