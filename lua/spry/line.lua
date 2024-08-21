local M = {}

M.config = {}

M.setup = function(config)
	M.config = vim.tbl_extend("force", M.config, config or {})
	vim.o.tabline = '%!v:lua.require("spry.line").tabLine()'
	vim.cmd([[
    highlight clear TabLineSel
    highlight clear TabLine
    highlight clear TabLineFill
    set termguicolors
    highlight TabLineSel guibg=#e6e9ef guifg=#222222 gui=bold
    highlight TabLine guibg=#e6e9ef guifg=#9Da0af
    highlight TabLineFill guibg=#eff1f6 guifg=#ffffff
    highlight TabLineSeparator guibg=#eff1f6 guifg=#eff1f6
  ]])
end

M.tabLine = function()
	local s = ""
	local padding = " " -- Adjust the padding here
	local separator = "│" -- Vertical bar as the separator

	for i = 1, vim.fn.tabpagenr("$") do
		-- Add a separator between tabs
		if i > 1 then
			s = s .. "%#TabLineSeparator#" .. separator
		end

		-- Check if this is the active tab
		if i == vim.fn.tabpagenr() then
			-- Active tab with custom highlighting
			s = s .. "%#TabLineSel#"
		else
			-- Inactive tabs
			s = s .. "%#TabLine#"
		end

		-- Get the buffer list and window number
		local buflist = vim.fn.tabpagebuflist(i)
		local winnr = vim.fn.tabpagewinnr(i)

		-- Get the buffer name or set it to "No Name"
		local filename = vim.fn.bufname(buflist[winnr])
		if filename == "" then
			filename = "• • •"
		else
			filename = vim.fn.fnamemodify(filename, ":t")
		end

		-- Tab name with padding
		s = s .. padding .. filename .. padding

		-- Modified flag
		if vim.fn.getbufvar(buflist[winnr], "&modified") == 1 then
			s = s .. " +"
		end

		s = s .. " %T"
	end

	-- Avoid the last tab taking up the remainder of the space
	s = s .. "%#TabLineFill#%="

	return s
end

return M
