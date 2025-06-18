return {
  -- Modern colorscheme with excellent syntax highlighting
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- storm, moon, night, day
      light_style = "day",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark", -- style for sidebars
        floats = "dark", -- style for floating windows
      },
      sidebars = { "qf", "help" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
      
      -- Integrate with git diff tools (delta compatibility)
      on_colors = function(colors)
        colors.git = {
          add = "#9ece6a",
          change = "#7aa2f7", 
          delete = "#f7768e",
        }
      end,
      
      on_highlights = function(highlights, colors)
        -- Better integration with modern tools
        highlights.DiffAdd = { bg = colors.git.add, fg = colors.bg_dark }
        highlights.DiffChange = { bg = colors.git.change, fg = colors.bg_dark }
        highlights.DiffDelete = { bg = colors.git.delete, fg = colors.bg_dark }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}