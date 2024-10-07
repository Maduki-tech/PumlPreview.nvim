---@class Logger
---@field lines string[]
---@field max_lines number
---@field enabled boolean
local Logger = {}

Logger.__index = Logger

function Logger:New()
	local this = {
		lines = {},
		max_lines = 100,
		enabled = false,
	}

	-- init keybinding for logs
	vim.keymap.set("n", "<leader>lg", Show, { silent = true })
	setmetatable(this, Logger)
	return this
end

function Logger:Log(...)
	if not self.enabled then
		return
	end
	local args = { ... }
	local line = table.concat(args, " ")
	table.insert(self.lines, line)
	if #self.lines > self.max_lines then
		table.remove(self.lines, 1)
	end
end

function Logger:Show()
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, self.lines)
	vim.api.nvim_win_set_buf(0, bufnr)
end

function Show()
	Logger:Show()
end

return Logger:New()
