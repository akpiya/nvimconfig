vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

local function show_branch_diff()
  local root = vim.fs.root(0, ".git")
  if not root then
    vim.notify("Not in a Git repository", vim.log.levels.WARN)
    return
  end

  local base = "origin/main"
  if vim.fn.executable("gh") == 1 then
    local result = vim.system({ "gh", "pr", "view", "--json", "baseRefName", "--jq", ".baseRefName" }, {
      cwd = root,
      text = true,
    }):wait()
    local branch = vim.trim(result.stdout or "")
    if result.code == 0 and branch ~= "" then
      base = "origin/" .. branch
    end
  end

  local result = vim.system({ "git", "diff", "--no-ext-diff", "--no-color", base .. "...HEAD" }, {
    cwd = root,
    text = true,
  }):wait()
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr or "git diff failed"), vim.log.levels.ERROR)
    return
  end
  if result.stdout == "" then
    vim.notify("No changes between " .. base .. " and HEAD")
    return
  end

  vim.cmd.tabnew()
  local buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(buffer, "git diff " .. base .. "...HEAD")
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, vim.split(result.stdout, "\n", { plain = true }))
  vim.bo[buffer].buftype = "nofile"
  vim.bo[buffer].bufhidden = "wipe"
  vim.bo[buffer].swapfile = false
  vim.bo[buffer].filetype = "diff"
  vim.bo[buffer].modifiable = false
  vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = buffer, desc = "Close Git diff" })
end

vim.keymap.set("n", "<leader>gd", show_branch_diff, { desc = "Open branch [G]it [D]iff" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
