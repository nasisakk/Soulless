local Utils = {}

--[[
	Split - Split based on a pattern or string
--]]
local function Utils.Split(pString, pPattern)
	local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(Table,cap)
		end
		
		last_end = e+1
		s, e, cap = pString:find(fpat, last_end)
	end
	
	if last_end <= #pString then
		cap = pString:sub(last_end)
		table.insert(Table, cap)
	end
	
	return Table
end

--[[
	contains
--]]
local function Utils.Contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	
	return false
end

--[[
	deepcopy
--]]
local function Utils.Deepcopy(orig)
	local orig_type = type(orig)
	local copy
	
	if orig_type == 'table' then
		copy = {}
		
		for orig_key, orig_value in next, orig, nil do
			copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
		end
		
		setmetatable(copy, Deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	
	return copy
end

return Utils