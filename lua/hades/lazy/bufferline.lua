return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/tokyonight.nvim',
  },
  config = function()

    vim.cmd.colorscheme("habamax")

    vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>")

    vim.opt.termguicolors = true
    require('bufferline').setup {}

    vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<cr>", { desc = "Next buffer"})
    vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<cr>", { desc = "Next buffer"})
  end
}
