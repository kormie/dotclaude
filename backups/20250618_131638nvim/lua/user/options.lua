-- Neovim options configuration

-- UI options
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true    -- Show relative line numbers
vim.opt.cursorline = true       -- Highlight current line
vim.opt.signcolumn = 'yes'      -- Always show sign column
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.scrolloff = 8           -- Minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8       -- Minimal number of screen columns to keep to the left and right of the cursor

-- Search options
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.ignorecase = true       -- Ignore case in search patterns
vim.opt.smartcase = true        -- Override ignorecase if search pattern contains uppercase

-- Tab and indent options
vim.opt.tabstop = 2             -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 2          -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true        -- Convert tabs to spaces
vim.opt.smartindent = true      -- Smart autoindent when starting a new line

-- Other options
vim.opt.backup = false          -- Don't make a backup before overwriting a file
vim.opt.swapfile = false        -- Don't use a swapfile for the buffer
vim.opt.undofile = true         -- Save undo history
vim.opt.updatetime = 300        -- Faster completion (default is 4000ms)
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
