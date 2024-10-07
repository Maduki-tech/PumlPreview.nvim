local logger = require("util.logger")

local M = {}

---@class preview.Renderer
---@field command string
---@field stdin boolean
---@field stdout boolean

---@return preview.Renderer
local function create_renderer(type)
	local renderer
	-- if type == "text" then
	-- 	renderer = text.Renderer:new()
	-- end
	return renderer
end

function M.setup()
	local default_opts = {
		previewer = {},
		render_on_write = false,
	}
	vim.api.nvim_create_user_command("PumlPreview", function()
		M.PumlPreview()
	end, {})
	local renderer = create_renderer("text")
	logger:log("renderer: ")
end

function M.PumlPreview()
	logger:log("PumlPreview")
end

return M
