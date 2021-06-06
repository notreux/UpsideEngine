local self = {}

for _, n in pairs(script:GetChildren()) do
	
	self[n.Name] = require(n)
	
end

return function(object, methods)
	
	for _, method in pairs(methods) do
		
		self[method](object);
		
	end
	
end;
