return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup({})
    vim.cmd.colorscheme("gruvbox")
    vim.cmd.hi("Comment gui=none")
  end,
}
