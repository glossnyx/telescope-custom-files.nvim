local Path = require("plenary.path")

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local state = require("telescope.actions.state")

local defaults = {
	path = Path:new({ vim.fn.stdpath("config"), "custom_files" }):absolute(),
	hidden = true,
}

local function custom_files(opts)
	local config = vim.tbl_deep_extend("keep", opts, defaults)

	builtin.find_files({
		prompt_title = "Custom Files",
		cwd = config.path,
		hidden = config.hidden,
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local source = state.get_selected_entry().path
				local basename = vim.fn.fnamemodify(source, ":tail")
				local destination = Path:new({ vim.loop.cwd(), basename }):absolute()

				Path:new(source):copy({ destination = destination })

				actions.close(prompt_bufnr)
			end)

			return true
		end,
	})
end

return require("telescope").register_extension({
	exports = {
		custom_files = custom_files,
	},
	setup = function(opts)
		defaults = vim.tbl_deep_extend("keep", opts, defaults)
	end,
})
