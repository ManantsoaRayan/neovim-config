return {
 'nvim-telescope/telescope-ui-select.nvim',
  config = function ()
    require("telescope").setup()
    require("telescope").load_extension("ui-select")
  end
}
