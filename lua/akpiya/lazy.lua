local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim")
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "akpiya.plugins" },
  },
  install = { colorscheme = { "gruvbox" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  rocks = { enabled = false },
})
