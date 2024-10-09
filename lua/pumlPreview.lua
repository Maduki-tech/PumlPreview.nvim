local logger = require("util.logger")
local text = require("renderer.text")

local M = {}
local filename = "pumlPreview.lua"

local renderer = nil

---@class preview.Options
---@field render_on_write boolean
---@field render_type 'text' | 'image'

---@class preview.Renderer
---@field renderer TextRenderer
---@field command string
---@field stdin boolean
---@field stdout boolean

---@return TextRenderer
---@param opts preview.Options
local function create_renderer(opts)
	if opts.render_type == "text" then
		return text.TextRenderer:new(opts)
	elseif opts.render_type == "image" then
		-- return image.ImageRenderer:new(opts)
		error("Image renderer not implemented yet")
	else
		error("Invalid render_type")
	end
end

---@param opts preview.Options
function M.setup(opts)
	--- Deafault options
	---@type preview.Options
	local default_opts = {
		render_type = "text",
		render_on_write = false,
	}

	opts = vim.tbl_extend("force", default_opts, opts)
	renderer = create_renderer(opts)

	logger:log(filename, "setup", opts)
	vim.api.nvim_create_user_command("PumlPreview", function()
		M.PumlPreview()
	end, {})

	if opts.render_on_write then
		vim.api.nvim_create_augroup("PumlPreview", {})
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.puml",
			group = "PumlPreview",
			callback = function()
				renderer:convertPumlToText()
			end,
		})
	end
end

--- Start the PumlPreview
function M.PumlPreview()
	logger:log(filename, "PumlPreview", "Starting PumlPreview")
	assert(renderer, "Renderer not initialized")
	renderer:convertPumlToText()
	renderer:show()
end

return M
