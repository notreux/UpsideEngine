local rs, data, __ = game:GetService("RunService"), require(script.Parent.Parent:WaitForChild("data")), {};

	function __:on(self, event_name, __function)
		
		if not self.events[event_name] then
			
			self.events[event_name] = {}
			
		end
		
		local index = #self.events[event_name] + 1;

		self.events[event_name].waiting = "///waiting///";
		
		self.events[event_name][index] = __function;

		return {
			
			wait = function()
				
				while self.events[event_name].waiting == "///waiting///" and wait() do end
				
				local ew = self.events[event_name].waiting;
				
				self.events[event_name].waiting = "///waiting///";
				
				return ew;
				
			end,
			
			disconnect = function()
				
				table.remove(self.events[event_name], index);
				
			end
			
		}
		
	end
	
	function __:fire(self, name, ...)
		
		self.events[name].waiting = ...;	
		
		for _, f in pairs(self.events[name] or {}) do
				
			f(...);
				
		end
		
	end

	function __:addTag(self, Tag)
		
		self.tags[Tag] = true;
		
	end
	
	function __:hasTag(self, Tag)

		return self.tags[Tag];

	end
	
	function __:removeTag(self, Tag)

		self.tags[Tag] = nil;

	end
	
	function __:tween(self, p, t, v)
		
		local init, vel, cn = self[p], self[p] - v/t, nil;
		
		cn = rs.Heartbeat:Connect(function()
			
			if (init > v == v < self[p] or init < v == v > self[p]) and wait(vel) then

				self[p] += vel;
				
			else
				
				cn:Disconnect();
				
			end
			
		end)
				
	end
	
	function __:checkCollision(self, meta)
		
		assert(meta and meta.inherited and meta.inherited[1] == "BaseObject", "Invalid object")
		
		return self.collisions[meta.index] and true or false;
				
	end
	
	function __:destroy() 
		
		self.fire("destroy");
		
		if data.robloxSpace[self.index] then
			
			data.robloxSpace[self.index]:Destroy();
			
			data.space[self.index] = nil;
			data.workspace[self.name] = nil;
			
		end	
		
	end
	
	function __:extend(self, class)

		local copy, metaCopy = data.robloxSpace[self.index]:Clone(), {};
		copy.Parent = data.robloxSpace[self.index].Parent;
		
		for index, val in pairs(self) do
			
			metaCopy[index] = val;
			
		end
		
		metaCopy.index = math.random();
		data.robloxSpace[metaCopy.index] = copy;
		
		local clon = setmetatable({}, data.getMetaData(metaCopy))(self.modules, class); 
		
		data.space[metaCopy.index] = clon;
		data.workspace[metaCopy.name] = clon;
		
		return clon;
		
	end
	
	function __.build(self, renderIn)
		
		renderIn = renderIn or game.StarterGui:FindFirstChildOfClass("ScreenGui") or game.StarterGui;
		
		local object = Instance.new("ImageLabel");
		object.Parent = renderIn;
		object.AnchorPoint = Vector2.new(0.5,0.5);
		
		for index, value in pairs(self.properties) do
			
			pcall(function()
				
				self.properties[index] = value;
				
			end)
			
		end
		
		data.robloxSpace[self.index] = object
	
		self.methods:fire("loaded", os.clock());
	
		self.loaded = true;
		
	end
	
return __;
