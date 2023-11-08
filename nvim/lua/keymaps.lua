
local M = {}

M.leaderkey = ','

M.core = {
  -- cancel search with <Esc>
  {'n', '<Esc>', ':noh<CR>'},

  -- stay in indent mode
  {'v', '<', '<gv^'},
  {'v', '>', '>gv^'},

  -- access global clipboard with Ctrl + {c,x,v}
  {'v', '<C-c>', '"+y'},
  {'v', '<C-x>', '"+c<Esc>'},
  {'n', '<C-v>', '"+p'},
  {'v', '<C-v>', 'c<Esc>"+p'},
  {'i', '<C-v>', '<C-r><C-o>+'},
}

M.treesitter_incremental_selection = {
  init_selection = '<S-l>',
  node_incremental = '<S-l>',
  -- scope_incremental = 'grc',
  node_decremental = '<S-h>',
}

M.treesitter_navigation = {
  -- goto_definition = 'gnd',
  -- list_definitions = 'gnD',
  -- list_definitions_toc = 'gO',
  goto_next_usage = 'gnn',
  goto_previous_usage = 'gnN',
}

M.telescope_builtin = {
  {'n', '<leader>ff', 'find_files'},
  {'n', '<leader>fg', 'live_grep'},
  {'n', '<leader>fb', 'buffers'},
  {'n', '<leader>fh', 'help_tags'},
}

M.lsp = {
  lsp_lines_toggle = { '', '<Leader>l' },
}

M.cmp = {
  scroll_down = '<C-j>',
  scroll_up = '<C-k>',
  try_complete = '<C-Space>',
  abort = '<C-e>',
  confirm = '<CR>',
  hop_forward = '<TAB>',
  hop_backward = '<S-TAB>',
}

return M

