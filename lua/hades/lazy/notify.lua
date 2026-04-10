return {
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        background_colour = "#000000",
      })
      vim.notify = require("notify")
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      notify = {
        enable = true,
      }
    },
    config = function()
      require("noice").setup({
        cmdline = {
          view = "cmdline_popup",
          format = {
            cmdline = { icon = ">" },
            search_down = { icon = "🔍⌄" },
            search_up = { icon = "🔍⌃" },
            filter = { icon = "$" },
            lua = { icon = "☾" },
            help = { icon = "?" },
          },
        },
        views = {
          cmdline_popup = {
            position = {
              row = 3,
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
        },
      })
    end,
  },
}
