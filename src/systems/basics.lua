local rs, data = game:GetService("RunService"), require(script.Parent.Parent:WaitForChild("data"));

return function(this)
	
	this.events = {};
	this.tags = {};
	
	function this.methods.on(event_name, __function)
		
		if not this.events[event_name] then
			
			this.events[event_name] = {}
			
		end
		
		local index = #this.events[event_name] + 1;

		this.events[event_name].waiting = "///waiting///";
		
		this.events[event_name][index] = __function;

		return {
			
			wait = function()
				
				while this.events[event_name].waiting == "///waiting///" and wait() do end
				
				local ew = this.events[event_name].waiting;
				
				this.events[event_name].waiting = "///waiting///";
				
				return ew;
				
			end,
			
			disconnect = function()
				
				table.remove(this.events[event_name], index);
				
			end
			
		}
		
	end
	
	function this.methods.fire(name, ...)
		
		this.events[name].waiting = ...;	
		
		for _, f in pairs(this.events[name] or {}) do
				
			f(...);
				
		end
		
	end

	function this.methods.addTag(Tag)
		
		this.tags[Tag] = true;
		
	end
	
	function this.methods.hasTag(Tag)

		return this.tags[Tag];

	end
	
	function this.methods.removeTag(Tag)

		this.tags[Tag] = nil;

	end
	
	function this.methods.tween(p, t, v)
		
		local init, vel, cn = this[p], this[p] - v/t, nil;
		
		cn = rs.Heartbeat:Connect(function()
			
			if (init > v == v < this[p] or init < v == v > this[p]) and wait(vel) then

				this[p] += vel;
				
			else
				
				cn:Disconnect();
				
			end
			
		end)
		
		this[p] = v;
		
	end
	
	function this.methods.checkCollision(meta)
		
		assert(meta and meta.inherited and meta.inherited[1] == "BaseObject", "Invalid object")
		
		return this.collisions[meta.index] and true or false;
				
	end
	
	function this.methods.destroy() 
		
		this.fire("destroy");
		
		if data.robloxSpace[this.index] then
			
			data.robloxSpace[this.index]:Destroy();
			
			data.space[this.index] = nil;
			data.workspace[this.name] = nil;
			
		end	
		
	end
	
	function this.methods.extend(class)

		local copy, metaCopy = data.robloxSpace[this.index]:Clone(), {};
		copy.Parent = data.robloxSpace[this.index].Parent;
		
		for index, val in pairs(this) do
			
			metaCopy[index] = val;
			
		end
		
		metaCopy.index = math.random();
		data.robloxSpace[metaCopy.index] = copy;
		
		local clon = setmetatable({}, data.getMetaData(metaCopy))(this.modules, class); 
		
		data.space[metaCopy.index] = clon;
		data.workspace[metaCopy.name] = clon;
		
		return clon;
		
	end
	
	function this.methods.build(renderIn)
		
		renderIn = renderIn or game.StarterGui:FindFirstChildOfClass("ScreenGui") or game.StarterGui;
		
		local object = Instance.new("ImageLabel");
		object.Parent = renderIn;
		object.AnchorPoint = Vector2.new(0.5,0.5);
		
		for index, value in pairs(this) do
			
			pcall(function()
				
				this[index] = value;
				
			end)
			
		end
		
		this.loaded = true;
		
	end
	
end
