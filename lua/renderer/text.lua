local logger = require("util.logger")

local M = {}

---@class TextRenderer
---@field buf number
---@field win number
---@field split_cmd string
M.TextRenderer = {}

---@return TextRenderer
function M.TextRenderer:new(opts)
	opts = opts or {}

	local buf = vim.api.nvim_create_buf(false, true)
	assert(buf ~= 0, "Failed to create buffer")

	self.__index = self
	return setmetatable({
		buf = buf,
		win = nil,
		split_cmd = "vsplit",
	}, self)
end

---@param content string[]
function M.TextRenderer:write(content)
	logger:log("TextRenderer:Write")
	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, content)
end

function M.TextRenderer:show()
	logger:log("TextRenderer:Show")
	self:create_window()
end

---@private
function M.TextRenderer:create_window()
	if not (self.win and vim.api.nvim_win_is_valid(self.win)) then
		vim.api.nvim_command("vsplit")
		self:write({ "Hello, World!" })
		self.win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(self.win, self.buf)
	end
end

return M
