vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"
vim.o.updatetime = 500

vim.opt.swapfile = false
vim.opt.splitright = true  -- vertical splits open to the right
vim.opt.splitbelow = true  -- horizontal splits open below
vim.opt.splitkeep = "screen" -- keep text on screen when splitting
vim.opt.equalalways = false      -- don't auto equalize on close

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- Force hjkl habit — disable arrow keys in normal, insert, and visual mode
vim.keymap.set({'n', 'v', 'i'}, '<Up>',    '<Nop>')
vim.keymap.set({'n', 'v', 'i'}, '<Down>',  '<Nop>')
vim.keymap.set({'n', 'v', 'i'}, '<Left>',  '<Nop>')
vim.keymap.set({'n', 'v', 'i'}, '<Right>', '<Nop>')
vim.wo.number = true

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= 'c' then vim.cmd("checktime") end
  end,
})

-- Toggle Claude Code in a tmux side pane
vim.keymap.set('n', '<leader>ai', function()
  local panes = vim.fn.system("tmux list-panes -s -F '#{pane_id} #{@is_claude}'")
  local claude_pane = nil
  for line in panes:gmatch("[^\n]+") do
    local pane_id, tag = line:match("^(%%%d+) (.+)$")
    if tag == "1" then
      claude_pane = pane_id
      break
    end
  end
  if claude_pane then
    vim.fn.system("tmux kill-pane -t " .. claude_pane)
  else
    vim.fn.system("tmux split-window -h -p 35 claude \\; set-option -p @is_claude 1")
  end
end, { desc = "Toggle Claude Code tmux pane" })
