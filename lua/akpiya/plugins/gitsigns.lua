return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "<leader>gd",
      function()
        require("gitsigns").diffthis(nil, { unified = true })
      end,
      desc = "Toggle unified [G]it [D]iff",
    },
  },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
}
