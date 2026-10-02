local parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(parsers)

    local group = vim.api.nvim_create_augroup("akpiya-treesitter", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(event)
        local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
        if not language or not vim.list_contains(parsers, language) then
          return
        end

        if pcall(vim.treesitter.start, event.buf, language) then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
