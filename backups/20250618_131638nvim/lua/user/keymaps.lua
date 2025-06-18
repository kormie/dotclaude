-- Keymaps configuration

-- Set leader key to comma
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

-- Double leader to clear search highlighting
map('n', '<leader><leader>', ':nohlsearch<CR>', { desc = 'Clear search highlighting' })

-- Better window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows with arrows
map('n', '<C-Up>', ':resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Down>', ':resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Navigate buffers
map('n', '<S-l>', ':bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-h>', ':bprevious<CR>', { desc = 'Previous buffer' })

-- Netrw - use '-' to open netrw in the current file's directory
map('n', '-', ':Explore<CR>', { desc = 'Open netrw in current file directory' })

-- Insert mode mappings

-- Press jk fast to exit insert mode
map('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })

-- Visual mode mappings

-- Stay in indent mode when changing indent in visual mode
map('v', '<', '<gv', { desc = 'Decrease indent and stay in Visual mode' })
map('v', '>', '>gv', { desc = 'Increase indent and stay in Visual mode' })

-- When moving selection, don't lose visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

-- Visual Block mode mappings

-- Move text up and down in visual block mode
map('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
map('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })
