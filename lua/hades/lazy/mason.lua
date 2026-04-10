---@diagnostic disable: undefined-global
return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      vim.keymap.set('n', '<leader>M', '<cmd>Mason<cr>')
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright" },
        automatic_installation = true,
        handlers = {
          function(server_name)
            -- skip dartls since flutter-tools handles it

            if server_name == "dartls" then
              return
            end

            require("lspconfig")[server_name].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities()
            })

            -- In your Neovim config (init.lua or lspconfig setup)
            require 'lspconfig'.dartls.setup {
              cmd = { "dart", "language-server", "--protocol=lsp" },
              filetypes = { "dart" },
              init_options = {
                closingLabels = true,
                flutterOutline = true,
                onlyAnalyzeProjectsWithOpenFiles = true,
                outline = true,
                suggestFromUnimportedLibraries = true
              },
              settings = {
                dart = {
                  completeFunctionCalls = true,
                  showTodos = true
                }
              }
            }
          end
        }
      })
    end
  }
}
