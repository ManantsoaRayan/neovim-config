return {
  "akinsho/flutter-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local flutter_tools = require("flutter-tools")
    flutter_tools.setup{
      lsp = {
        color = {
          enabled = false, -- show colors in the editor
        },
        on_attach = function(client, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', '<leader>fr', '<cmd>FlutterRun<cr>', opts)
          vim.keymap.set('n', '<leader>fd', '<cmd>FlutterDevices<cr>', opts)
          vim.keymap.set('n', '<leader>frt', '<cmd>FlutterRestart<cr>', opts)
          vim.keymap.set('n', '<leader>fq', '<cmd>FlutterQuit<cr>', opts)
          vim.keymap.set('n', '<leader>fo', '<cmd>FlutterOutlineToggle<cr>', opts)
          vim.keymap.set('n', '<leader>fe', '<cmd>FlutterEmulators<cr>', opts)
          vim.keymap.set('n', '<leader>frr', '<cmd>FlutterReload<cr>', opts)
        end,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "prompt",
          enableSnippets = true,
        }
      },
      ui = {
        notification_style = "native"
      },
      decorations = {
        statusline = {
          app_version = false,
          device = true,
        }
      },
      dev_log = {
        enabled = true,
        open_cmd = "tabedit", -- command to open the log buffer
      },
    }
  end
}
