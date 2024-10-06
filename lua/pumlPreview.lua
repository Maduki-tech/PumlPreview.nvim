local M = {}

---@class preview.Renderer
---@field command string
---@field stdin boolean
---@field stdout boolean

---@return preview.Renderer
local function create_renderer(type)
	local renderer
	if type == "text" then
		renderer = text.Renderer:new()
	end
	return renderer
end

function M.setup()
	local default_opts = {
		previewer = {},
		render_on_write = false,
	}
	local renderer = create_renderer("text")
end

return M
