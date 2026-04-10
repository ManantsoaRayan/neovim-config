vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text, signs = not vim.diagnostic.config().signs, underline = not vim.diagnostic.config().underline })<CR>', { noremap = true, silent = true, desc = "Toggle Diagnostics" })


