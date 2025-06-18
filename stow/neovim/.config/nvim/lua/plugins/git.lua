return {
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to next hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to previous hunk" })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "git [h]unk [s]tage" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "git [h]unk [r]eset" })
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [h]unk [s]tage" })
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [h]unk [r]eset" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "git [h]unk [S]tage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "git [h]unk [u]ndo stage" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "git [h]unk [R]eset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "git [h]unk [p]review" })
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, { desc = "git [h]unk [b]lame line" })
        map("n", "<leader>hB", gs.toggle_current_line_blame, { desc = "git [h]unk toggle [B]lame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "git [h]unk [d]iff against index" })
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, { desc = "git [h]unk [D]iff against last commit" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "git [i]nner [h]unk" })
      end,
    },
  },

  -- Enhanced git integration with Fugitive
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = {"fugitive"},
    keys = {
      {"<leader>ga", ":Git add %:p<CR><CR>", desc = "git add current file"},
      {"<leader>gs", ":Git<CR>", desc = "git status"},
      {"<leader>gc", ":Git commit<CR>", desc = "git commit"},
      {"<leader>gd", ":Gdiffsplit<CR>", desc = "git diff split"},
      {"<leader>gb", ":Git blame<CR>", desc = "git blame"},
      {"<leader>gl", ":Git log<CR>", desc = "git log"},
      {"<leader>gp", ":Git push<CR>", desc = "git push"},
      {"<leader>gP", ":Git pull<CR>", desc = "git pull"},
    },
  },

  -- Git commit browser - integrates with delta/difftastic
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
      git_cmd = { "git" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {}
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {}
        },
      },
      commit_log_panel = {
        win_config = {
          win_opts = {},
        }
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {
        diff_buf_read = function(bufnr)
          -- Change local options in diff buffers
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = { 80 }
        end,
        view_opened = function(view)
          print(("A new %s was opened on tab page %d!"):format(view.class:name(), view.tabpage))
        end,
      },
      -- Use default keymaps to avoid loading issues
      keymaps = {
        disable_defaults = false, -- Use the well-tested default keymaps
      },
    },
    keys = {
      { "<leader>gv", ":DiffviewOpen<CR>", desc = "Git diffview open" },
      { "<leader>gV", ":DiffviewClose<CR>", desc = "Git diffview close" },
      { "<leader>gh", ":DiffviewFileHistory<CR>", desc = "Git file history" },
      { "<leader>gH", ":DiffviewFileHistory %<CR>", desc = "Git current file history" },
    },
  },
}