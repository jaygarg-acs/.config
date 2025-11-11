vim.keymap.set({"n", "v"}, " ", "<Nop>")
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fd", vim.cmd.Ex)

-- vim.keymap.set({"n", "v"},"<C-d>", "<C-d>zz")
-- vim.keymap.set({"n", "v"}, "<C-u>", "<C-u>zz")
vim.keymap.set({"n", "v"}, "<C-Down>", "<C-d>zz")
vim.keymap.set({"n", "v"}, "<C-Up>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
--vim.keymap.set("v", "<leader>p", "\"rd\"0P")
--vim.keymap.set("v", "<leader>p", "\"rd\"0p")
--vim.keymap.set("n", "<leader>p", "\"0p")

function is_visual_selection_ends_at_eol()
  local mode = vim.api.nvim_get_mode().mode
  if mode:find('v') then -- Check if in visual mode (v, V, or Ctrl-V)
    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')
    if start_pos and end_pos then
      local end_row = end_pos[1]
      local end_col = end_pos[2]
      local line = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, false)[1]
      
      -- Account for 0-indexed column value from API vs 1-indexed string length
      -- We need to add 1 to end_col to properly compare with line length
      return end_col + 1 >= #line
    end
  end
  return false -- Not in visual mode or no selection
end

vim.keymap.set("v", "<leader>p", function()
    -- We don't need the debug echo in the final version
    local ends_at_eol = is_visual_selection_ends_at_eol()
    if ends_at_eol then
        -- If at end of line, delete to black hole and paste after
        return '"rd"0p'
    else
        -- If in middle of text, delete to black hole and paste before
        return '"rd"0P'
    end
end, { expr = true, desc = "Replace visual selection with yanked text" })

vim.keymap.set("v", "<leader>c", "gc", {remap = true})
vim.keymap.set("n", "<leader>c", "gcc", {remap = true})

-- Mixed/camel/Pascal → snake_case over the given range of LINES
vim.api.nvim_create_user_command("Sn", function(opts)
  local l1, l2 = opts.line1, opts.line2
  -- Split ALLCAPS→Cap boundaries (XMLHttp → XML_Http) — harmless if no match
  vim.cmd(string.format("%d,%ds/\\v([A-Z]+)([A-Z][a-z])/\\1_\\2/ge", l1, l2))
  -- Split lower/digit→Cap boundaries (fooBar → foo_Bar)
  vim.cmd(string.format("%d,%ds/\\v([a-z0-9])([A-Z])/\\1_\\2/ge", l1, l2))
  -- Lowercase the whole range
  vim.cmd(string.format("%d,%dnormal! guu", l1, l2))
end, { range = true, desc = "Convert MixedCase to snake_case (linewise)" })

-- Visual mode shortcut (linewise)
vim.keymap.set("x", "<leader>sn", ":Sn<CR>", { desc = "MixedCase→snake_case" })

