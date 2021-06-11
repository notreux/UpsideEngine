local main = setmetatable({}, {});

-- arrays, variables and others

main.space = {};
main.robloxSpace = {};
main.workspace = setmetatable({}, {});

-- methods

function main.getMetaData(this)

	local metaData = {};

	function metaData:__index(index)
		
		local ro;
		
		pcall(function()
			
			local i = index:sub(1,1);
			i = i:upper() .. index:sub(2, #index);
			
			ro = main.robloxSpace[this.index][i]; 
			
		end);
		
		return this[index]
			or this.properties[index]
			or this.functions[index]
			or ro or nil;

	end

	function metaData.__newindex(__this, index, val)
		
		local currentVal = this.functions[index] or this.properties[index] or nil;
		
		if this.fire then this:fire("changed", index);end;
		
		if index == "name" and typeof(val) ~= "string" then
			
			return error("The object name must be a string.");
			
		elseif index == "name" and main.workspace[val] then
							
			return error("There's already another object with this name! You must specify a name that has no other object.");
							
		elseif index == "name" then
			
			main.workspace[val] = main.workspace[this.index];

			main.workspace[this.properties.name] = nil;
			
		end

		if currentVal and typeof(currentVal) ~= typeof(val) then

			return error(string.format("%s must be a %s", index, typeof(currentVal)));

		end
		
		coroutine.wrap(pcall)(function()
			
			if not this.loaded and this.on then this:on('loaded'):wait(); end
			
			local obj, i = main.robloxSpace[this.index], index:sub(1,1);
			i = i:upper() .. index:sub(2, #index);

			obj[i] = typeof(val) == "Vector2" and UDim2.new(val.X, 0, val.Y, 0) or val;
			
			if (index == "position" or index == "size") and this.properties.canCollide then

				coroutine.wrap(require(script.Parent.Internal).updateSpace)(__this)

			end
			
		end)


		if this.base then
		
			this[index] = val;
			
		elseif typeof(val) == "function" then

			this.functions[index] = val;

		else

			this.properties[index] = val;

		end
		
	end

	function metaData:__len()

		return error("Expected identifier when parsing expression, got '#'");

	end

	function metaData:__tostring()
		
		return this.properties.name .. "; inherited from: " .. this.inherited;

	end

	function metaData.__call(__this, generic, newClass)
		
		generic = typeof(generic) == "table" and generic or {generic};
		
		if not this.modules then
			
			this.modules = generic;
			
		else
			
			for _, val in pairs(generic) do
				
				this.modules[#this.modules + 1] = val;
				
			end
			
		end
		
		this.inherited ..=  this.class ~= newClass and newClass .. ", " or "";
		
		this.class = typeof(newClass) == "string" and newClass or this.class;

		require(script.Parent.systems)(__this, this, generic);
		
	end
	
	return metaData;
	
end;

return main;
