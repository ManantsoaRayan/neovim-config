return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  cmd = { "VenvSelect" },
  ft = "python",
  keys = { { ",v", "<cmd>VenvSelect<cr>" } },
  config = function()
    require("venv-selector").setup({
      settings = {
        options = {
          fd_binary_name = "fd",
          log_level = "trace",
        },
        search = {
          venv = false,
          cwd = false,
          workspace = false,
          my_projects = {
            command = "fd --hidden --no-ignore /bin/python$ /home/rayan --full-path -E /proc",
            -- command = "fd --hidden --no-ignore /bin/python$ /home/rayan/projects/study --full-path -E /proc",
          },
        },
      },
    })
  end,
}
