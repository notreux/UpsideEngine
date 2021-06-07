local self = setmetatable({}, {});

-- arrays, variables and others

self.space = {};
self.robloxSpace = {};
self.workspace = setmetatable({}, {});

-- methods

function self.getMetaData(this, directAcces)

	local metaData = {};

	function metaData:__index(index)
		
		local ro;
		
		pcall(function() ro = self.robloxSpace[this.index][index]; end);
		
		return ro or this.properties[index]
			or this.functions[index]
			or this.methods[index]
			or this[index]
			or nil;

	end

	function metaData:__newindex(index, val)
		
		local currentVal = this.functions[index] or this.properties[index] or nil;
		
		if this.fire then this.fire("changed", index);end;
		
		if index == "name" and typeof(val) ~= "string" then
			
			return error("The object name must be a string.");
			
		elseif index == "name" and self.workspace[val] then
							
			return error("There's already another object with this name! You must specify a name that has no other object.");
							
		elseif index == "name" then
				
			self.workspace[this.properties.name] = nil;
			
			self.workspace[val] = self.space[this.index];
			
		end
		
		if currentVal and typeof(currentVal) ~= typeof(val) then

			return error(string.format("%s must be a %s", index, typeof(currentVal)));

		end
		
		spawn(pcall(function()
			
			if not this.loaded and this.on then this.on('loaded'):wait(); end
						
			local obj, i = self.robloxSpace[this.index], index:sub(1,1);
			i = i:upper() .. index:sub(2, string.len(index));

			if obj and obj[i] then

				local v = val;			

				if typeof(v) == "Vector2" then

					v = UDim2.new(v.X, 0, v.Y, 0);

				end

				obj[i] = val;
				
			end
			
		end))
		
		if this.base then
			
			if typeof(this[index]) == "function" then
				this.methods[index] = val;
			else
				this[index] = val;
			end
			
		elseif typeof(val) == "function" then

			this.functions[index] = val;

		else

			this.properties[index] = val;

		end
		
		if (index == "position" or index == "size") and this.canCollide then
			
			spawn(require(script.Parent.Internal).updateSpace(this))

		end
		
	end

	function metaData:__len()

		return error("Expected identifier when parsing expression, got '#'");

	end

	function metaData:__tostring()
		
		return this.properties.name .. "; inherited from: " .. this.inherited;

	end

	function metaData:__call(generic, newClass)
		
		generic = typeof(generic) == "table" and generic or {generic};
		
		if not this.modules then
			
			directAcces.modules = generic;
			
		else
			
			for _, val in pairs(generic) do
				
				directAcces.modules[#this.modules + 1] = val; 
				
			end
			
		end
		
		directAcces.inherited ..=  this.class ~= newClass and newClass .. ", " or "";
		
		directAcces.class = typeof(newClass) == "string" and newClass or this.class;

		require(script.Parent.systems)(this, directAcces, generic);
		
	end
	
	return metaData;
	
end;

return self;
