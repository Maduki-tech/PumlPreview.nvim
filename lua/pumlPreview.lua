local logger = require("util.logger")
local text = require("renderer.text")

local M = {}
local filename = "pumlPreview.lua"

---@class preview.Renderer
---@field command string
---@field stdin boolean
---@field stdout boolean

-- TODO: Check for Types so it will be expandable

---@return TextRenderer
local function create_renderer(type, opts)
	local renderer = text.TextRenderer:new(opts)
	return renderer
end

function M.setup()
	--- Deafault options
	local default_opts = {
		previewer = {},
		render_on_write = false,
	}
	-- TODO: make the user able to add there own config

	vim.api.nvim_create_user_command("PumlPreview", function()
		M.PumlPreview(default_opts)
	end, {})
end

--- Start the PumlPreview
function M.PumlPreview(opts)
	logger:log(filename, "PumlPreview", "Starting PumlPreview")
	local renderer = create_renderer("text", opts)

	renderer:show()
end

return M
