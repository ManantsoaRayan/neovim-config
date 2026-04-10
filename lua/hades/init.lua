vim.g.mapleader = " "

-- set keybinding to close a window with <leader>q
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })

vim.opt.number = true

vim.diagnostic.disable = true

require("hades.set")
require("hades.remap")
require("hades.lazy_init")


-- setup local AI integration

vim.keymap.set("n", "<leader>ai", function()
  require("hades.local_ai").telescope_inline()
end)

vim.diagnostic.config({
    underline = false,
    virtual_text = true,
    signs = true,
})
