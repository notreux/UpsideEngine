local module = {}

for _, Service in ipairs(script:GetChildren()) do
	if not Service.Name:match(".spec") then
		module[Service.Name] = require(Service)
	end
end

return module
