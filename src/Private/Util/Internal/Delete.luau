local appData = script.Parent.Parent.Parent.Parent.AppData
local data = require(appData.Data)
local default = {}

function delete(obj)
	for key, val in (obj or default) do
		if typeof(val) ~= "table" then
			obj[key] = nil
		elseif val.Id and data.objects[val.Id] or typeof(val) == "Instance" then
			val:Destroy()
		else
			delete(obj[key])
			obj[key] = nil
		end
	end
end

return delete
