-- Enhanced keymaps configuration
-- Built on user's existing comma leader preference with modern enhancements

-- Set leader key to comma (user preference)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Helper function for creating keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Normal mode mappings

-- Double leader to clear search highlighting (user's existing preference)
map('n', '<leader><leader>', ':nohlsearch<CR>', { desc = 'Clear search highlighting' })

-- Better window navigation (preserving user's C-hjkl preference)
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows with arrows (user's existing preference)
map('n', '<C-Up>', ':resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Down>', ':resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Navigate buffers (user's existing preference)
map('n', '<S-l>', ':bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-h>', ':bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })

-- File explorer - using '-' for Neo-tree (enhanced file navigation)
map('n', '-', function() 
  require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("%:p:h") }) 
end, { desc = 'Open Neo-tree in current file directory' })

-- Enhanced file operations
map('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>W', ':wa<CR>', { desc = 'Save all files' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
map('n', '<leader>Q', ':qa<CR>', { desc = 'Quit all' })

-- Enhanced text manipulation
map('n', 'J', 'mzJ`z', { desc = 'Join lines and restore cursor position' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down and center' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up and center' })
map('n', 'n', 'nzzzv', { desc = 'Next search result and center' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result and center' })

-- Better paste behavior
map('x', '<leader>p', [["_dP]], { desc = 'Paste without overwriting register' })

-- System clipboard operations
map({'n', 'v'}, '<leader>y', [["+y]], { desc = 'Yank to system clipboard' })
map('n', '<leader>Y', [["+Y]], { desc = 'Yank line to system clipboard' })
map({'n', 'v'}, '<leader>d', [["_d]], { desc = 'Delete without affecting register' })

-- Quick substitution
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Substitute word under cursor' })

-- Make file executable
map('n', '<leader>x', '<cmd>!chmod +x %<CR>', { desc = 'Make file executable', silent = false })

-- Insert mode mappings

-- Press jk fast to exit insert mode (user's existing preference)
map('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })

-- Better completion navigation
map('i', '<C-j>', '<C-n>', { desc = 'Next completion item' })
map('i', '<C-k>', '<C-p>', { desc = 'Previous completion item' })

-- Visual mode mappings

-- Stay in indent mode when changing indent (user's existing preference)
map('v', '<', '<gv', { desc = 'Decrease indent and stay in Visual mode' })
map('v', '>', '>gv', { desc = 'Increase indent and stay in Visual mode' })

-- Better text movement (user's existing preference)
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

-- Visual Block mode mappings (user's existing preference)
map('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
map('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

-- Enhanced visual operations
map('v', '<leader>y', [["+y]], { desc = 'Yank selection to system clipboard' })

-- Terminal mode mappings
map('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = 'Move to left window from terminal' })
map('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = 'Move to lower window from terminal' })
map('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = 'Move to upper window from terminal' })
map('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = 'Move to right window from terminal' })
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Command mode mappings
map('c', '<C-j>', '<C-n>', { desc = 'Next command history' })
map('c', '<C-k>', '<C-p>', { desc = 'Previous command history' })

-- Function keys for Claude Code workflows
map('n', '<F1>', ':term<CR>', { desc = 'Open terminal' })
map('n', '<F2>', ':!tmux split-window -h "claude-code ."<CR><CR>', { desc = 'Launch Claude Code in tmux pane' })
map('n', '<F3>', ':!git status<CR>', { desc = 'Quick git status' })
map('n', '<F4>', ':!git log --oneline -10<CR>', { desc = 'Quick git log' })