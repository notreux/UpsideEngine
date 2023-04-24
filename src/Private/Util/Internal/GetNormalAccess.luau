local upsideEngine = script.Parent.Parent.Parent.Parent
local data = require(upsideEngine.AppData.Data)

return function(object)
	return data.workSpace[object.Name] or object
end
