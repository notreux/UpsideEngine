local appData = script.Parent.Parent.Parent.Parent.AppData
local data = require(appData.Data)

function copyTable(__table, copyIn)
	local copy = copyIn or {}

	for key, value in __table do
		if typeof(value) ~= "table" then
			copy[key] = value
		elseif value.Id and data.restricted[value.Id] then
			local _, obj = pcall(value.new, value)
			copy[key] = obj
		else
			copy[key] = copyTable(value, copy[key])
		end
	end

	return copy
end

return copyTable
