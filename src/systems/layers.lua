local data, contentProvider, rs, __ = require(script.Parent.Parent:WaitForChild("data")), game:GetService("ContentProvider"), game:GetService("RunService"), {};


function __:setLayer(self, name, layers, rectSize, frames)

	assert(typeof(name) == "string", "You must define a valid name!");

	contentProvider:PreloadAsync(typeof(layers) == "table" and layers or {layers});

	self.layers[name] = {

		layers = layers;
		frames = frames;
		rectSize = rectSize or Vector2.new();

	};

	self.actions[name] = false;

end

function __.play(self, name)

	self.playing = false;

	if not self.loaded then self.on('loaded'):wait(); end

	self.methods:fire("layerStarted", name, unpack(self.layers[name]))

	self.playing = true;

	local object, cn = data.robloxSpace[self.index], nil;		

	object.ImageRectSize = self.layers[name].rectSize;

	local function everySprite(layer)

		object.Image = layer;

		wait(self.properties.spriteSpeed)

	end

	local function everyFrame(frame)

		object.ImageRectOffset = frame * object.ImageRectSize;

		wait(self.properties.spriteSpeed);

	end		

	cn = rs.Heartbeat:Connect(function()

		if self.playing then

			table.foreach(self.layers[name].frames or self.layers, self.layers[name].frames and everyFrame or everySprite)

		else cn:Disconnect();

		end

	end)

end

function __.stop(self, name)

	self.methods:fire("layerStarted", name, unpack(self.layers[name]));
	self.playing = false;
	self.actions[name] = false;

end


return __;
