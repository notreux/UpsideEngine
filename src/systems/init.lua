local self = {};

for _, n in pairs(script:GetChildren()) do

	self[n.Name] = require(n);

end

return function(object, directAccess, systems)

	for _, system in pairs(systems) do

		for block, methods in pairs(self[system]) do

			for index, method in pairs(methods) do

				object[index] = function(...)

					local params = {...};

					assert(typeof(params[1]) == "table" and params[1].index and params[1].index == object.index, "Expected ':' not '.' calling member method " .. index);

					table.remove(params, 1);

					params = block == 'direct' and {directAccess, unpack(params)}
							 or {object, unpack(params)} 
					
					return block ~= 'onLoaded' and method(unpack(params)) or spawn(function()

						if not object.loaded and object.on then object:on('loaded'):wait(); end

						return method(unpack(params));

					end)
					
				end

			end

		end 

	end

end
