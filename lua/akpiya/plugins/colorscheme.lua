return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup({})
  end, init = function()
    vim.cmd.colorscheme('gruvbox')
    vim.cmd.hi('Comment gui=none')
  end,
}
