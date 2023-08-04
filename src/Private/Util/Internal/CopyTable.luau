local appData = script.Parent.Parent.Parent.Parent.AppData
local objects = require(appData.Data).objects

function copyTable(__table, copyIn)
	local copy = copyIn or {}

	for key, value in __table do
		if typeof(value) ~= "table" then
			copy[key] = value
		elseif value.Id and objects[value.Id] then
			local _, obj = pcall(value.new, value)
			copy[key] = obj
		else
			copy[key] = copyTable(value, copy[key])
		end
	end

	return copy
end

return copyTable
