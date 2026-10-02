return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("akpiya-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        local builtin = require("telescope.builtin")

        map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
        map("gr", builtin.lsp_references, "[G]oto [R]eferences")
        map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
        map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local inlay_hint = vim.lsp.protocol.Methods.textDocument_inlayHint
        if client and client:supports_method(inlay_hint, event.buf) then
          map("<leader>th", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local servers = {
      clangd = {},
      gopls = {},
      pyright = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
          },
        },
      },
    }

    for name, config in pairs(servers) do
      config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
      vim.lsp.config(name, config)
    end

    local server_names = vim.tbl_keys(servers)
    require("mason-lspconfig").setup({
      ensure_installed = server_names,
      automatic_enable = server_names,
    })

    vim.lsp.config("nil_ls", { capabilities = capabilities })
    vim.lsp.enable("nil_ls")
  end,
}
