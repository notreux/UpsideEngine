local modules = {}

for _, val in ipairs(script:GetDescendants()) do
	if not val.Name:match(".spec") and val.Parent:IsA("Folder") then
		modules[val.Name] = require(val)
	end
end

return modules
