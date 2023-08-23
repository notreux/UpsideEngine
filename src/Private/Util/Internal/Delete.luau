local appData = script.Parent.Parent.Parent.Parent.AppData
local data = require(appData.Data)
local default = {}

function delete(obj)
	for key, val in (obj or default) do
		local valueType = typeof(val)
		if valueType ~= "table" and valueType ~= "Instance" then
			obj[key] = nil
		elseif valueType == "Instance" or val.Id and data.objects[val.Id] == val then
			val:Destroy()
		else
			delete(obj[key])
			obj[key] = nil
		end
	end
end

return delete
