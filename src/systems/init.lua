local self, exclusivePermissions = {}, {

	"play",
	"stop",
	"build"	

};

for _, n in pairs(script:GetChildren()) do

	self[n.Name] = require(n)

end

return function(object, directAcces, systems)

	for _, system in pairs(systems) do

		local system = self[system];

		for index, method in pairs(system) do

			if table.find(exclusivePermissions, method) then

				object[system] = function(...)
					
					local params = {...};

					assert(params[1] and params[1].index and params[1].index == object.index, "Expected ':' not '.' calling member method " .. method);
					
					table.remove(params, 1);
					
					self[system](directAcces, params);
					
				end
					
			else
				
				object[system] = self[system];
				
			end 

		end

	end

end;
