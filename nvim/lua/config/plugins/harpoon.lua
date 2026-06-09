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

      local function is_abs(p)
        if not p or p == "" then
          return false
        end
        if p:sub(1, 1) == "/" then
          return true
        end
        if p:match("^%a:[/\\]") then
          return true
        end
        return false
      end

      local function realpath(p)
        if not p or p == "" then
          return nil
        end
        p = vim.fn.expand(p)
        p = vim.fn.fnamemodify(p, ":p")
        return vim.loop.fs_realpath(p) or p
      end

      local function get_root_dir()
        local l = list()
        if l and l.config and type(l.config.get_root_dir) == "function" then
          local ok, root = pcall(l.config.get_root_dir, l.config)
          if ok and type(root) == "string" and root ~= "" then
            return root
          end
        end

        -- fallback: git root from current cwd, else cwd
        local cwd = vim.loop.cwd() or ""
        local root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
        return (root and root ~= "") and root or cwd
      end

      local function item_to_abs_path(item)
        if type(item) ~= "table" then
          return nil
        end
        local v = item.value or item.path or item.filename or item[1]
        if type(v) ~= "string" or v == "" then
          return nil
        end

        -- Your harpoon items are repo-root-relative (as shown in :inspect output)
        if not is_abs(v) then
          v = get_root_dir() .. "/" .. v
        end

        return realpath(v)
      end

      local function buf_abs_path()
        local name = vim.api.nvim_buf_get_name(0)
        if name == "" then
          return nil
        end
        return realpath(name)
      end

      local function harpoon_index_for_current_buffer()
        local buf = buf_abs_path()
        if not buf then
          return nil
        end

        local items = list().items or {}
        for i, item in ipairs(items) do
          local ip = item_to_abs_path(item)
          if ip and ip == buf then
            return i
          end
        end
        return nil
      end

      local function sync_indices_from_buffer()
        local idx = harpoon_index_for_current_buffer()
        if idx and idx ~= curr_idx then
          if curr_idx ~= nil then
            last_idx = curr_idx
          end
          curr_idx = idx
        end
      end

      -- Telescope buffer changes can complete after the initial event fires;
      -- schedule the sync so it runs after the buffer is actually current.
      local function sync_indices_scheduled()
        vim.schedule(sync_indices_from_buffer)
      end

      vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWinEnter", "BufFilePost", "BufReadPost" },
        { callback = sync_indices_scheduled }
      )

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
        -- If you navigated into a harpooned file via Telescope, this makes it count.
        sync_indices_from_buffer()

        if last_idx then
          curr_idx, last_idx = last_idx, curr_idx
          list():select(curr_idx)
        else
          vim.cmd("b#")
        end
      end, { desc = "Harpoon: go to last selected file" })
    end,
  },
}
