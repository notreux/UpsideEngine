local rs, data, __ = game:GetService("RunService"), require(script.Parent.Parent:WaitForChild("data")), { direct = {}, fast = {}, onLoaded = {}; };

function __.fast.on(this, event_name, __function)

	if not this.events[event_name] then

		this.events[event_name] = {}

	end

	local index = #this.events[event_name] + 1;

	this.events[event_name].waiting = not this.events[event_name].waiting == "///waiting///" or this.events[event_name].waiting;

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

function __.fast.fire(self, name, ...)

	if not self.events[name] then

		self.events[name] = {}

	end

	self.events[name].waiting = ...;	

	for index, f in pairs(self.events[name]) do

		if index ~= "waiting" then

			coroutine.wrap(f)(...);

		end

	end

end

function __.fast.addTag(self, Tag)

	self.tags[Tag] = true;

end

function __.fast.hasTag(self, Tag)

	return self.tags[Tag];

end

function __.fast.removeTag(self, Tag)

	self.tags[Tag] = nil;

end

function __.fast.tween(self, p, t, v)

	local init, vel, cn = self[p], self[p] - v/t, nil;

	cn = rs.Heartbeat:Connect(function()

		if (init > v == v < self[p] or init < v == v > self[p]) and wait(vel) then

			self[p] += vel;

		else

			cn:Disconnect();

		end

	end)

end

function __.onLoaded.checkCollision(self, meta)

	assert(meta and meta.inherited and meta.inherited[1] == "BaseObject", "Invalid object")

	return self.collisions[meta.index] and true or false;

end

function __.onLoaded.destroy(self) 

	self:fire("destroyed", os.clock());

	if data.robloxSpace[self.index] then

		data.robloxSpace[self.index]:Destroy();

		data.space[self.index] = nil;
		data.workspace[self.name] = nil;

	end	

end

function __.onLoaded.extend(self, class, props)
		
	local metaCopy =  { properties = {}, functions = {}, base = true };

	for index, val in pairs(self.properties) do
		
		metaCopy.properties[index] = val;

	end
	
	for index, val in pairs(self.functions) do

		metaCopy.functions[index] = val;

	end
	
	metaCopy.inherited = self.inherited;
	
	metaCopy.events = {};
	metaCopy.collisions = {};
	
	metaCopy.events = {};
	metaCopy.tags = {};
	
	metaCopy.index = math.random();

	local clon = setmetatable({}, data.getMetaData(metaCopy)); 
	clon(self.modules, class)
	clon.base = false;
	clon.name = self.name ~= clon.name and clon.name or clon.name .. tostring(math.random());
	
	data.space[clon.index] = clon;
	data.workspace[clon.name] = clon;
	for index, value in pairs(props) do
		
		clon[index] = value;
		
	end
	
	return clon;

end

function __.direct.build(self, renderIn)

	renderIn = renderIn or game.StarterGui:FindFirstChildOfClass("ScreenGui") or game.StarterGui;

	local object = Instance.new("ImageLabel");
	object.Parent = renderIn;
	object.AnchorPoint = Vector2.new(0.5,0.5);
	object.BackgroundTransparency = 1;
	object.Image = self.properties.image or "";
	
	data.robloxSpace[self.index] = object;
	
	self.loaded = true;
	self:fire("loaded", os.clock());
	
	for index, value in pairs(self.properties) do

		pcall(function()

			data.space[self.index][index] = value;

		end)

	end

end

function __.onLoaded.applySymmetry(this)

	spawn(function()
		
		if not this.loaded then this:on("loaded"):wait(); end;
		
		Instance.new("UIAspectRatioConstraint").Parent = data.robloxSpace[this.index];
				
	end)

end

function __.onLoaded.setParallax(this, v2)
	
	data.robloxSpace[this.index].ScaleType = Enum.ScaleType.Tile;
	
	local function update()
		
		data.robloxSpace[this.index].TileSize = UDim2.new(0, workspace.Camera.ViewportSize.X + this.scroll.X, 0, workspace.Camera.ViewportSize.X + this.scroll.Y) ;

	end
	
	update();
	
	this.scroll = v2;
	
	local cn = workspace.Camera:GetPropertyChangedSignal('ViewportSize'):Connect(update);
	
	return {
		
		rotate = function(_, _v2)	
			
			assert(typeof(_v2) == 'Vector2' and data.robloxSpace[this.index].ScaleType == Enum.ScaleType.Tile, 'Parallax error.');
			
			data.robloxSpace[this.index].TileSize += UDim2.new(0, _v2.X, 0, _v2.Y)
			
			this.scroll = _v2;
			
		end,
		
		disable = function()
			
			cn:Disconnect();
			
			data.robloxSpace[this.index].ScaleType = Enum.ScaleType.Stretch;
			
		end
		
	}
	
end

return __;
