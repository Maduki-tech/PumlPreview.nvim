local utils = require("util.utils")

---@class Logger
---@field lines string[]
---@field max_lines number
---@field enabled boolean
local Logger = {}

Logger.__index = Logger

--- Create a new Logger instance
---@return Logger
function Logger:New()
	local logger = setmetatable({
		lines = {},
		max_lines = 100,
		enable = true,
	}, self)
	vim.keymap.set("n", "<leader>lg", Show, { silent = true })

	return logger
end

--- Log messages to the new buffer
function Logger:log(...)
	local prcessed = {}
	for i = 1, select("#", ...) do
		local item = select(i, ...)
		if type(item) == "table" then
			item = vim.inspect(item)
		end
		table.insert(prcessed, item)
	end

	local lines = {}
	for _, line in ipairs(prcessed) do
		local split = utils.split(line, "\n")
		for _, l in ipairs(split) do
			if not utils.is_white_space(l) then
				local ll = utils.trim(utils.remove_duplicate_whitespace(l))
				table.insert(lines, ll)
			end
		end
	end

	table.insert(self.lines, table.concat(lines, " "))

	while #self.lines > self.max_lines do
		table.remove(self.lines, 1)
	end
end

--- Show the logs in a new buffer
function Logger:Show()
	local bufnr = vim.api.nvim_create_buf(false, true)
	print(vim.inspect(self.lines))
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, self.lines)
	vim.api.nvim_win_set_buf(0, bufnr)
end

function Show()
	require("util.logger"):Show()
end

return Logger:New()
