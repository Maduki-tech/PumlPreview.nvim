local logger = require("util.logger")
local utils = require("util.utils")

local M = {}
local filename = "renderer/text.lua"

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
	assert(type(content) == "table", "Content must be a table")
	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, content)
end

---@private
function M.TextRenderer:create_window()
	if not (self.win and vim.api.nvim_win_is_valid(self.win)) then
		vim.api.nvim_command(self.split_cmd)
		self.win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(self.win, self.buf)
	end
end

---@private
function M.TextRenderer:convertPumlToText()
	local currentOpenFilePath = vim.api.nvim_buf_get_name(0)
	logger:log(filename, "TextRenderer:convertPumlToText", currentOpenFilePath)

	local handle = io.popen("cat " .. currentOpenFilePath .. " | plantuml -tutxt -pipe")
	assert(handle, "Failed to open handle")
	local output = handle:read("*a")
	handle:close()

	logger:log(filename, "TextRenderer:convertPumlToText", output)
	local lines = self:convertOutputToTable(output)
	self:write(lines)
end

---@private
---@param ... string
---@return string[]
function M.TextRenderer:convertOutputToTable(...)
	local processed = {}

	for i = 1, select("#", ...) do
		local item = select(i, ...)
		if type(item) == "table" then
			item = vim.inspect(item)
		end
		table.insert(processed, item)
	end

	local lines = {}
	for _, line in ipairs(processed) do
		local split = utils.split(line, "\n")
		for _, l in ipairs(split) do
			if not utils.is_white_space(l) then
				local ll = utils.trim(utils.remove_duplicate_whitespace(l))
				table.insert(lines, ll)
			end
		end
	end

	return lines
end

function M.TextRenderer:show()
	logger:log(filename, "TextRenderer:Show", "Showing TextRenderer")
	-- TODO: Generate the text file with pumlcli tool
	self:convertPumlToText()
	self:create_window()
end

return M
