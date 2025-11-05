return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			vim.keymap.set('n', '<leader>M', '<cmd>Mason<cr>')
			require("mason").setup()
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright" },
				automatic_installation = false,
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities
						})
					end
				}
			})
		end
	}
}
