vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

local function git_root()
  local root = vim.fs.root(0, ".git")
  if not root then
    vim.notify("Not in a Git repository", vim.log.levels.WARN)
  end
  return root
end

local function run_git_diff(root, args)
  local command = { "git", "diff", "--no-ext-diff", "--no-color" }
  vim.list_extend(command, args)
  return vim.system(command, { cwd = root, text = true }):wait()
end

local function open_git_diff(root, args, title)
  local result = run_git_diff(root, args)
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr or "git diff failed"), vim.log.levels.ERROR)
    return
  end
  if result.stdout == "" then
    vim.notify("No changes for " .. title)
    return
  end

  vim.cmd.tabnew()
  local buffer = vim.api.nvim_get_current_buf()

  local function render(output)
    vim.bo[buffer].modifiable = true
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, vim.split(output, "\n", { plain = true }))
    vim.bo[buffer].modifiable = false
  end

  vim.api.nvim_buf_set_name(buffer, title .. " [" .. buffer .. "]")
  vim.bo[buffer].buftype = "nofile"
  vim.bo[buffer].bufhidden = "wipe"
  vim.bo[buffer].swapfile = false
  vim.bo[buffer].filetype = "diff"
  render(result.stdout)

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = buffer, desc = desc, silent = true })
  end

  map("q", "<cmd>tabclose<cr>", "Close Git diff")
  map("]f", function()
    vim.fn.search("^diff --git ", "W")
  end, "Next changed file")
  map("[f", function()
    vim.fn.search("^diff --git ", "bW")
  end, "Previous changed file")
  map("]h", function()
    vim.fn.search("^@@", "W")
  end, "Next diff hunk")
  map("[h", function()
    vim.fn.search("^@@", "bW")
  end, "Previous diff hunk")
  map("R", function()
    local refreshed = run_git_diff(root, args)
    if refreshed.code ~= 0 then
      vim.notify(vim.trim(refreshed.stderr or "git diff failed"), vim.log.levels.ERROR)
      return
    end
    render(refreshed.stdout ~= "" and refreshed.stdout or "No changes for " .. title)
    vim.notify("Refreshed " .. title)
  end, "Refresh Git diff")
end

local function show_local_diff()
  local root = git_root()
  if not root then
    return
  end
  open_git_diff(root, { "HEAD" }, "git diff HEAD")
end

local function show_branch_diff()
  local root = git_root()
  if not root then
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

  open_git_diff(root, { base .. "...HEAD" }, "git diff " .. base .. "...HEAD")
end

vim.keymap.set("n", "<leader>gd", show_local_diff, { desc = "Open local [G]it [D]iff" })
vim.keymap.set("n", "<leader>gb", show_branch_diff, { desc = "Open [G]it [B]ranch diff" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
