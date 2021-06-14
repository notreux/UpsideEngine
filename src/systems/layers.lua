local data, contentProvider, rs, __ = require(script.Parent.Parent:WaitForChild("data")), game:GetService("ContentProvider"), game:GetService("RunService"), { direct = {} };

function __.direct.setLayer(self, name, layers, rectSize, frames)
	
	assert(typeof(name) == "string", "You must define a valid name!");

	contentProvider:PreloadAsync(typeof(layers) == "table" and layers or {layers});

	self.layers[name] = {

		layers = layers;
		frames = frames;
		rectSize = rectSize or Vector2.new();

	};

	self.actions[name] = false;
		
end

function __.direct.play(self, name, speed)
		

	if not self.loaded then self:on('loaded'):wait(); end
	
	if self.playing then self:stop(); end;
		
	self:fire("layerStarted", name, self.layers[name] and unpack(self.layers[name]) or nil);

	self.playing = true;
	self.actions[name] = true;

	local object, ended = data.robloxSpace[self.index], true;		
	object.Image = typeof(self.layers[name].layers) == "string" and self.layers[name].layers or self.layers[name][1]
	object.ImageRectSize = self.layers[name].rectSize;

	local function everySprite(layer)

		object.Image = layer;

		wait(speed or self.properties.spriteSpeed)

	end

	local function everyFrame(frame)

		object.ImageRectOffset = frame * self.layers[name].rectSize;
		
		wait(speed or self.properties.spriteSpeed);

	end
	
	local f = (self.layers[name].frames and everyFrame or everySprite);
	
	self.heartbeat = rs.Heartbeat:Connect(function()

		if ended then
			
			ended = false;
			
			for _, frame in pairs(self.layers[name].frames or self.layers[name]) do
				
				f(frame)
				
			end
			
			ended = true;
			
		end

	end)

end

function __.direct.stop(self, name)
	
	self.playing = false;
	
	if not name then
	
		for index, value in pairs(self.actions) do
		
			self.actions[index] = false;
		
		end
		
	else
		
		self.actions[name] = false;
		
	end
	
	self:fire("layerEnded", name, unpack(self.layers[name] or {}));
	
	return self.heartbeat and self.heartbeat:Disconnect() or nil;
		
end


return __;
