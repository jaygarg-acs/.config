return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Better header (clean, recognizable, works with color highlights)
      dashboard.section.header.val = {
      " ⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      " ⠀⣤⣤⣤⡄⢸⣿⣿⣿⣿⣿⣿⡇⠀⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      " ⠀⣿⣿⣿⣇⠈⠉⠉⠉⠉⠉⠉⠁⢀⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⠀⣤⣤⣤⣤⠀ ",
      " ⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⠀ ",
      " ⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠘⠛⠛⠛⠛⢛⣿⠟⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠀⠀⠙⠛⠛⠛⠛⠛⠛⠛⠛⠃⠘⠛⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣶⣶⣶⡶⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠋⠛⠻⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠷⠶⠶⠶⠾⢿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠀⢀⣀⣾⣏⠀⠀⠀⠀⠀⠀⠀⣹⣧⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ",
      " ⠀⠀⠀⠀⠾⠿⠿⠿⠿⠷⠄⠀⠀⠀⠴⠿⠿⠿⠿⠿⠷⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      "                                ",
      "   █████╗  ██████╗███████╗    ",
      "  ██╔══██╗██╔════╝██╔════╝    ",
      "  ███████║██║     ███████╗    ",
      "  ██╔══██║██║     ╚════██║    ",
      "  ██║  ██║╚██████╗███████║    ",
      "  ╚═╝  ╚═╝ ╚═════╝╚══════╝    ",
      }

      -- Buttons (more options, still not dense)
      dashboard.section.buttons.val = {
        dashboard.button("s", "Recently latest session", "<cmd>SessionRestore<cr>"),
        dashboard.button("o", "Recently opened files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("f", "Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("g", "Find word", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("b", "Buffers", "<cmd>Telescope buffers<cr>"),
        dashboard.button("p", "Projects", "<cmd>Telescope projects<cr>"),
        dashboard.button("t", "Themes", "<cmd>Telescope colorscheme enable_preview=true<cr>"),
        dashboard.button("n", "New file", "<cmd>ene | startinsert<cr>"),
        dashboard.button("c", "Config", "<cmd>edit ~/.config/nvim<cr>"),
        dashboard.button("u", "Update plugins", "<cmd>Lazy update<cr>"),
        dashboard.button("l", "Plugin manager", "<cmd>Lazy<cr>"),
        dashboard.button("q", "Quit", "<cmd>qa<cr>"),
      }

      -- Footer: show loaded packages (works with lazy.nvim)
      local function footer()
        local ok, lazy = pcall(require, "lazy")
        if ok then
          local stats = lazy.stats()
          return ("neovim loaded %d packages"):format(stats.count)
        end
        return ""
      end
      dashboard.section.footer.val = footer()

      -- Layout: more centered like your reference image
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 1 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        dashboard.section.footer,
      }

      -- Bring back color (subtle, theme-driven; not rainbow)
      -- Pick highlight groups that most colorschemes style nicely:
      dashboard.section.header.opts.hl = "Title"
      dashboard.section.buttons.opts.hl = "Normal"
      dashboard.section.footer.opts.hl = "Comment"

      -- Make shortcut keys pop a bit (right-side key column)
      for _, btn in ipairs(dashboard.section.buttons.val) do
        btn.opts.hl_shortcut = "Keyword"
      end

      alpha.setup(dashboard.config)
    end,
  },
}
