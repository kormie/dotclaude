# Vim Integration for Claude Code Workflows

Deep integration between Vim/Neovim and tmux for seamless Claude Code development workflows.

## Integration Philosophy

The DotClaude system is built around vim workflow patterns:
- **Consistent keybindings** between vim and tmux
- **CapsLock→Ctrl optimization** for ergonomic navigation
- **Comma leader key** matching your vim mapleader
- **Seamless pane switching** between vim splits and tmux panes

## Smart Navigation Integration

### Vim-Tmux Navigation

The tmux configuration includes intelligent pane switching that detects when you're in vim:

```bash
# Smart navigation that works in both vim and tmux
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
```

**How It Works:**
- **In vim**: `C-hjkl` moves between vim splits
- **In tmux**: `C-hjkl` moves between tmux panes
- **Seamless**: No context switching needed

### Required Vim Configuration

Add to your vim/neovim configuration for seamless integration:

```vim
" Vim-tmux navigation integration
" Add to ~/.vimrc or ~/.config/nvim/init.lua

" Vim script version (.vimrc)
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
    endif
  endfunction

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
endif
```

```lua
-- Neovim Lua version (init.lua)
if vim.env.TMUX then
  local function tmux_or_split_switch(wincmd, tmuxdir)
    local previous_winnr = vim.fn.winnr()
    vim.cmd('wincmd ' .. wincmd)
    if previous_winnr == vim.fn.winnr() then
      vim.fn.system('tmux select-pane -' .. tmuxdir)
    end
  end

  vim.keymap.set('n', '<C-h>', function() tmux_or_split_switch('h', 'L') end, { silent = true })
  vim.keymap.set('n', '<C-j>', function() tmux_or_split_switch('j', 'D') end, { silent = true })
  vim.keymap.set('n', '<C-k>', function() tmux_or_split_switch('k', 'U') end, { silent = true })
  vim.keymap.set('n', '<C-l>', function() tmux_or_split_switch('l', 'R') end, { silent = true })
end
```

## Claude Code Workflow Integration

### Multi-Worktree Vim Usage

**Workflow Pattern:**
1. **Tmux Pane 1**: Claude Code session in `feature-auth` worktree
2. **Tmux Pane 2**: Claude Code session in `feature-api` worktree
3. **Tmux Pane 3**: Vim session in main repository
4. **Tmux Pane 4**: Git operations

**Vim Usage Patterns:**

```vim
" Working with multiple worktrees in vim
:cd /path/to/main/repo              " Main repository
:lcd .worktrees/feature-auth        " Local directory for current buffer
:args .worktrees/feature-auth/**    " Load files from specific worktree

" Quick worktree switching
:command! AuthWorktree lcd .worktrees/feature-auth
:command! ApiWorktree lcd .worktrees/feature-api
:command! MainRepo cd /path/to/main/repo
```

### Vim Sessions for Claude Code

**Session Management:**
```vim
" Session management for Claude Code workflows
:mksession! claude-session.vim      " Save current session
:source claude-session.vim          " Restore session

" Project-specific sessions
:mksession! sessions/feature-auth.vim
:mksession! sessions/feature-api.vim
```

**Auto-session Configuration:**
```vim
" Auto-save sessions for Claude Code projects
augroup ClaudeCodeSessions
  autocmd!
  autocmd VimLeave * if exists('g:claude_session') | 
    \ execute 'mksession! ' . g:claude_session | endif
augroup END

" Set session for current Claude Code workspace
:let g:claude_session = 'sessions/' . $TMUX_PANE . '.vim'
```

## Advanced Vim Configuration

### Neovim Configuration for Claude Code

**Modern Neovim Setup (`~/.config/nvim/init.lua`):**
```lua
-- Claude Code optimized Neovim configuration
vim.g.mapleader = ","  -- Match tmux secondary leader

-- Enhanced file navigation for worktrees
vim.opt.path:append('.worktrees/**')
vim.opt.wildignore:append('**/node_modules/**')
vim.opt.wildignore:append('**/.git/**')

-- Git integration
vim.keymap.set('n', '<leader>gs', ':Git status<CR>')
vim.keymap.set('n', '<leader>gd', ':Git diff<CR>')
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')

-- Claude Code specific commands
vim.keymap.set('n', '<leader>cw', ':!cw %:h:t<CR>')  -- Launch workspace for current project
vim.keymap.set('n', '<leader>ct', ':terminal<CR>')   -- Quick terminal
```

### File Explorer Integration

**Netrw Configuration:**
```vim
" Netrw optimized for Claude Code workflows
let g:netrw_banner = 0              " Disable banner
let g:netrw_liststyle = 3           " Tree view
let g:netrw_browse_split = 3        " Open in new tab
let g:netrw_winsize = 25            " Width percentage

" Quick worktree navigation
nnoremap <leader>ew :Explore .worktrees/<CR>
nnoremap <leader>er :Explore<CR>
```

**Modern File Explorer (if using nvim-tree):**
```lua
-- nvim-tree configuration for Claude Code
require('nvim-tree').setup({
  view = {
    mappings = {
      list = {
        { key = "<leader>w", action = "cd_worktree" },
        { key = "<leader>r", action = "cd_root" },
      }
    }
  },
  filters = {
    custom = { ".git", "node_modules", ".cache" }
  }
})

-- Custom actions for worktree navigation
local api = require('nvim-tree.api')
vim.keymap.set('n', '<leader>ew', function()
  api.tree.change_root('.worktrees')
end)
```

## Copy Mode Integration

### Tmux Copy Mode with Vim Bindings

**Enhanced Copy Mode:**
```bash
# Copy mode behaves like vim visual mode
bind Escape copy-mode                 # Enter copy mode (ESC)
bind p paste-buffer                   # Paste (vim-like)

# Visual selection (vim-style)
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"

# Movement (vim-style)
bind -T copy-mode-vi H send-keys -X start-of-line
bind -T copy-mode-vi L send-keys -X end-of-line
bind -T copy-mode-vi w send-keys -X next-word
bind -T copy-mode-vi b send-keys -X previous-word

# Search (vim-style)
bind -T copy-mode-vi / command-prompt -i -p "search down" "send -X search-forward-incremental \"%%%\""
bind -T copy-mode-vi ? command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""
```

### Vim-Tmux Clipboard Integration

**Shared Clipboard Configuration:**
```vim
" Vim clipboard integration with tmux
if exists('$TMUX')
  " Use tmux clipboard
  set clipboard=unnamed
  
  " Custom copy command that updates tmux buffer
  vnoremap <silent> y y:call system('tmux load-buffer -', @")<CR>
  
  " Paste from tmux buffer
  nnoremap <silent> <leader>p :let @"=system('tmux save-buffer -')<CR>p
endif
```

## Git Integration

### Git Worktree Vim Commands

**Custom Vim Commands for Worktrees:**
```vim
" Git worktree management from within vim
command! -nargs=1 GitWorktreeAdd call system('git worktree add .worktrees/' . <q-args> . ' ' . <q-args>)
command! -nargs=1 GitWorktreeRemove call system('git worktree remove .worktrees/' . <q-args>)
command! GitWorktreeList !git worktree list

" Quick worktree navigation
command! -nargs=1 Worktree execute 'cd .worktrees/' . <q-args>
command! MainRepo cd ../..

" Worktree-aware git commands
nnoremap <leader>gw :GitWorktreeList<CR>
nnoremap <leader>ga :GitWorktreeAdd 
nnoremap <leader>gr :GitWorktreeRemove 
```

### Delta Integration

**Enhanced Diff Viewing:**
```vim
" Use delta for git diffs in vim
if executable('delta')
  " Custom diff command using delta
  command! -nargs=* Gdelta !git diff <args> | delta
  
  " View file diff with delta
  nnoremap <leader>gD :execute '!git diff ' . expand('%') . ' | delta'<CR>
endif

" Difftastic integration
if executable('difft')
  command! -nargs=* Gdifft execute '!env GIT_EXTERNAL_DIFF=difft git diff ' . <q-args>
  nnoremap <leader>gd :execute '!env GIT_EXTERNAL_DIFF=difft git diff ' . expand('%')<CR>
endif
```

## Color Scheme Integration

### Coordinated Color Schemes

**Matching Themes:**
- **Tmux**: Dracula theme
- **Git Delta**: Dracula syntax theme
- **Vim**: Dracula or compatible color scheme
- **Terminal**: Dracula or compatible colors

**Vim Color Configuration:**
```vim
" Color scheme coordination with tmux/delta
if exists('$TMUX')
  " Enhanced colors for tmux
  set termguicolors
  
  " Dracula theme (install via plugin manager)
  colorscheme dracula
  
  " Status line colors that match tmux
  hi StatusLine guibg=#6272a4 guifg=#f8f8f2
  hi StatusLineNC guibg=#44475a guifg=#f8f8f2
endif
```

## Performance Optimization

### Vim Performance in Tmux

**Optimizations for Tmux Environment:**
```vim
" Performance optimizations for tmux
set lazyredraw                    " Don't redraw during macros
set ttyfast                       " Fast terminal connection
set ttimeoutlen=10               " Reduce escape sequence timeout

" Tmux-specific optimizations
if exists('$TMUX')
  set clipboard=unnamed           " Use system clipboard
  set mouse=a                     " Enable mouse support
  set ttymouse=xterm2            " Mouse support in tmux
endif
```

### Large File Handling

**Optimizations for Claude Code Projects:**
```vim
" Handle large files efficiently
augroup LargeFileOptimizations
  autocmd!
  " For files larger than 10MB
  autocmd BufReadPre * if getfsize(expand('<afile>')) > 10485760 |
    \ setlocal noswapfile bufhidden=unload eventignore+=FileType |
    \ endif
augroup END

" Exclude large directories from search
set wildignore+=*/node_modules/*,*/build/*,*/dist/*,*/.git/*
```

## Troubleshooting

### Common Integration Issues

**Navigation Not Working:**
```bash
# Check if vim-tmux navigation is properly configured
echo $TMUX                    # Should show tmux session info
ps -o comm= -t $(tty)        # Should detect vim when running

# Test tmux pane detection
tmux display-message -p "#{pane_tty}"
```

**Clipboard Issues:**
```vim
" Debug clipboard integration
:echo has('clipboard')        " Should return 1
:echo &clipboard             " Should show 'unnamed' or similar
:version                     " Check for +clipboard support
```

**Color Issues:**
```vim
" Debug color support
:echo &termguicolors         " Should be 1 in modern terminals
:echo $TERM                  " Should be screen-256color or similar
:set background?             " Check if dark/light is correctly detected
```

## Best Practices

### Workflow Recommendations

1. **Session Management**: Use vim sessions for each major feature branch
2. **Window Layout**: Keep vim in dedicated tmux pane for focused editing
3. **File Navigation**: Use vim's built-in file explorer for project navigation
4. **Git Integration**: Leverage vim-fugitive or similar for git operations
5. **Search Integration**: Use ripgrep from within vim for fast project search

### Keybinding Consistency

1. **Leader Key**: Use comma (`,`) consistently between vim and tmux
2. **Navigation**: Maintain hjkl patterns throughout
3. **Copy/Paste**: Use consistent clipboard shortcuts
4. **Window Management**: Similar patterns for splits and tabs

### Performance Tips

1. **Lazy Loading**: Load plugins only when needed
2. **File Filtering**: Exclude irrelevant files from searches
3. **Syntax Limiting**: Disable syntax highlighting for very large files
4. **Buffer Management**: Close unused buffers regularly

The vim integration provides seamless development experience within Claude Code workflows, maintaining consistency with your existing vim muscle memory while adding powerful tmux integration for multi-session development.

## Next Steps

- **[Git Worktrees](/claude-code/worktrees)** - Deep dive into parallel development
- **[Session Management](/claude-code/sessions)** - Advanced session patterns
- **[Best Practices](/claude-code/best-practices)** - Proven workflow patterns