return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function ()
    require("telescope").setup()
    vim.keymap.set("n", "<leader>e", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>")
  end
}

