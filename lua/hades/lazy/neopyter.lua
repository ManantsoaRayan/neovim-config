return {
  "SUSTech-data/neopyter",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',   -- neopyter don't depend on `nvim-treesitter`, but does depend on treesitter parser of python
    'AbaoFromCUG/websocket.nvim',        -- for mode='direct'
  },

  opts = {
    mode = "remote",
    remote_address = "127.0.0.1:8888",
    token = "jupyter",
    file_pattern = { "*.ju.*", "*.py" },
    auto_connect = true,
    inline_plot = true,
    on_attach = function(buf)
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {desc = desc, buffer = buf})
      end

      map("n", "<leader>Enter", "<cmd>Neopyter execute notebook:run-cell<cr>", "run selected")

      map("n", "<F5>", "<cmd>Neopyter execute current:run-cell<cr>", "Run current cell")

      map("n", "<leader>X", "<cmd>Neopyter execute notebook:run-all-above<cr>", "run all above cell")

    end,
  },

  config = function(_, opts)
    require("neopyter").setup(opts)
  end
}
