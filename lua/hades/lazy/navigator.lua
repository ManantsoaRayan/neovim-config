return {
  "numToStr/Navigator.nvim",
  config = function()
    require("Navigator").setup({
      -- optional configuration here
    })
    vim.keymap.set("n", "<C-h>", "<Cmd>NavigatorLeft<CR>", { desc = "Go to left split" })
    vim.keymap.set("n", "<C-j>", "<Cmd>NavigatorDown<CR>", { desc = "Go to down split" })
    vim.keymap.set("n", "<C-k>", "<Cmd>NavigatorUp<CR>", { desc = "Go to upper split" })
    vim.keymap.set("n", "<C-l>", "<Cmd>NavigatorRight<CR>", { desc = "Go to right split" })
  end
}
