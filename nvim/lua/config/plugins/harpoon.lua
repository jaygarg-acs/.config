return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup({
        settings = {
          save_on_change = true,
          save_on_toggle = true,
          sync_on_ui_close = true, -- optional but recommended for persistence
          key = function()
            -- repo root if possible, else cwd
            local cwd = vim.loop.cwd() or ""
            local root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
            local base = (root and root ~= "") and root or cwd

            -- current branch (fallback if not a git repo / errors)
            local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD 2>/dev/null")[1]
            if not branch or branch == "" then
              branch = "no-branch"
            end

            -- unique storage key: per-repo, per-branch
            return base .. "::" .. branch
          end,
        },
      })

      -- DO NOT cache the list; always fetch it
      local function list()
        return harpoon:list()
      end

      -- add & menu
      vim.keymap.set("n", "<leader>a", function()
        list():add()
      end, { desc = "Harpoon add file" })

      vim.keymap.set("n", "<leader>h", function()
        harpoon.ui:toggle_quick_menu(list())
      end, { desc = "Harpoon menu" })

      -- track last/current selected Harpoon index
      local last_idx, curr_idx

      local function goto_idx(i)
        if curr_idx ~= nil then
          last_idx = curr_idx
        end
        curr_idx = i
        list():select(i) -- re-fetch list so the current branch key is used
      end

      for i = 1, 9 do
        local idx = i
        vim.keymap.set("n", "<leader>" .. idx, function()
          goto_idx(idx)
        end, { desc = ("Harpoon go to file %d"):format(idx) })
      end

      vim.keymap.set("n", "<leader><Tab>", function()
        if last_idx then
          curr_idx, last_idx = last_idx, curr_idx
          list():select(curr_idx) -- again, re-fetch list
        else
          vim.cmd("b#")
        end
      end, { desc = "Harpoon: go to last selected file" })
    end,
  },
}
