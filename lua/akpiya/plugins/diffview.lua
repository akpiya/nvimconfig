return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = {
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewOpen",
    "DiffviewRefresh",
    "DiffviewToggleFiles",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open [G]it [D]iff" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file [G]it [H]istory" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repository [G]it [H]istory" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close [G]it diff view" },
  },
  opts = {
    use_icons = vim.g.have_nerd_font,
  },
}
