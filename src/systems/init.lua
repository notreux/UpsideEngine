local self = {}

for _, n in pairs(script:GetChildren()) do
	
	self[n] = require(n)
	
end

return function(object, methods)
	
	table.foreach(methods, function(method)
		
		self[method](object);
		
	end)
	
end;
