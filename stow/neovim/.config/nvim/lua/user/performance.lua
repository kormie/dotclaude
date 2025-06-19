-- Performance optimizations for Neovim
-- These settings improve startup time and runtime performance

-- Disable some builtin vim plugins to improve startup time
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

-- Disable netrw since we use Neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Performance settings
vim.opt.updatetime = 300  -- Faster completion and diagnostics
vim.opt.timeoutlen = 500  -- Faster key sequence timeout
vim.opt.redrawtime = 1500  -- Prevent very slow redrawing
vim.opt.synmaxcol = 240   -- Don't syntax highlight very long lines

-- Better search performance
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Memory optimizations
vim.opt.hidden = true     -- Allow switching buffers without saving
vim.opt.history = 1000    -- Reasonable command history
vim.opt.undolevels = 1000 -- Reasonable undo history

-- Faster file operations
vim.opt.swapfile = false  -- Disable swap files for better performance
vim.opt.backup = false    -- Disable backup files
vim.opt.writebackup = false -- But keep writebackup disabled too

-- Better scrolling performance
vim.opt.lazyredraw = true
vim.opt.ttyfast = true

-- UI performance
vim.opt.termguicolors = true
vim.opt.pumheight = 15    -- Limit popup menu height
vim.opt.winminheight = 1  -- Allow very small splits

return {}