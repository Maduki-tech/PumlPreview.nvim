local logger = require("util.logger")
local text = require("renderer.text")

local M = {}

---@class preview.Renderer
---@field command string
---@field stdin boolean
---@field stdout boolean

---@return TextRenderer
local function create_renderer(type, opts)
	local renderer = text.TextRenderer:new(opts)
	return renderer
end

function M.setup()
	local default_opts = {
		previewer = {},
		render_on_write = false,
	}
	vim.api.nvim_create_user_command("PumlPreview", function()
		M.PumlPreview(default_opts)
	end, {})
end

function M.PumlPreview(opts)
	logger:log("PumlPreview")
	local renderer = create_renderer("text", opts)
	renderer:show()
end

return M
