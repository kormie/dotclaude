-- Enhanced Neovim options configuration
-- Built on user's existing preferences with modern enhancements

-- UI options
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.cursorline = true       -- Highlight current line
vim.opt.signcolumn = 'yes'      -- Always show sign column
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.scrolloff = 8           -- Minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8       -- Minimal number of screen columns to keep to the left and right of the cursor
vim.opt.colorcolumn = "80"      -- Show column ruler at 80 characters
vim.opt.conceallevel = 0        -- Don't hide characters

-- Search options
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.ignorecase = true       -- Ignore case in search patterns
vim.opt.smartcase = true        -- Override ignorecase if search pattern contains uppercase
vim.opt.incsearch = true        -- Show match as search proceeds

-- Tab and indent options
vim.opt.tabstop = 2             -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 2          -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true        -- Convert tabs to spaces
vim.opt.smartindent = true      -- Smart autoindent when starting a new line
vim.opt.breakindent = true      -- Enable break indent

-- File handling
vim.opt.backup = false          -- Don't make a backup before overwriting a file
vim.opt.swapfile = false        -- Don't use a swapfile for the buffer
vim.opt.undofile = true         -- Save undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.writebackup = false     -- Don't write backup

-- Performance and behavior
vim.opt.updatetime = 50         -- Faster completion (default is 4000ms)
vim.opt.timeoutlen = 300        -- Time to wait for a mapped sequence to complete
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.mouse = 'a'             -- Enable mouse mode
vim.opt.completeopt = { 'menuone', 'noselect' } -- Completion options

-- Window splitting
vim.opt.splitbelow = true       -- Force all horizontal splits below current window
vim.opt.splitright = true       -- Force all vertical splits to right of current window

-- File encoding
vim.opt.fileencoding = "utf-8"  -- File content encoding for the buffer

-- Enhanced UI
vim.opt.termguicolors = true    -- Enable 24-bit RGB colors
vim.opt.pumheight = 10          -- Maximum number of entries in a popup
vim.opt.showtabline = 2         -- Always show tabs
vim.opt.laststatus = 3          -- Global statusline
vim.opt.cmdheight = 1           -- Command line height
vim.opt.showmode = false        -- Don't show mode (status line shows it)

-- Folding (using treesitter when available)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false      -- Don't fold by default

-- Better grep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case --follow"
  vim.opt.grepformat = "%f:%l:%c:%m"
end