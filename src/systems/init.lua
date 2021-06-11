local self, exclusivePermissions = {}, {
	
	"setLayer",
	"play",
	"stop",
	"build"	

};

for _, n in pairs(script:GetChildren()) do

	self[n.Name] = require(n);

end

return function(object, directAccess, systems)

	for _, system in pairs(systems) do

		for index, method in pairs(self[system]) do
			
			object[index] = function(...)

				local params = {...};
				
				assert(typeof(params[1]) == "table" and params[1].index and params[1].index == object.index, "Expected ':' not '.' calling member method " .. index);

				table.remove(params, 1);
				
				local toSend = table.find(exclusivePermissions, index) and {directAccess, unpack(params)}
					or {object, unpack(params)} 
				
				return method(unpack(toSend));

			end
			
		end 

	end

end
