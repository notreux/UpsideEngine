local data, contentProvider, rs = require(script.Parent.Parent.data), game:GetService("ContentProvider"), game:GetService("RunService");

return function(this)
	
	this.methods.spriteSpeed = 0.05;
	this.layers = {};
	this.actions = {};
	
	function this.methods.setLayer(name, layers, rectSize, frames)
		
		assert(typeof(name) == "string", "You must define a valid name!");
		
		contentProvider:PreloadAsync(typeof(layers) == "table" and layers or {layers});

		this.layers[name] = {
			
			layers = layers;
			frames = frames;
			rectSize = rectSize or Vector2.new();
			
		};
		
		this.actions[name] = false;

	end
	
	function this.methods.play(name)
		
		this.playing = false;
		
		if not this.loaded then this.on('loaded'):wait(); end
		
		this.playing = true;

		local object, cn = data.robloxSpace[this.index], nil;		
		
		object.ImageRectSize = this.layers[name].rectSize;
		
		local function everySprite(layer)

			object.Image = layer;

			wait(this.spriteSpeed)

		end
		
		local function everyFrame(frame)

			object.ImageRectOffset = frame * object.ImageRectSize;

			wait(this.spriteSpeed);

		end		
		
		cn = rs.Heartbeat:Connect(function()
			
			if this.playing then
								
				table.foreach(this.layers[name].frames or this.layers, this.layers[name].frames and everyFrame or everySprite)
				
			else cn:Disconnect();
				
			end
				
		end)
			
	end
	
	function this.methods.stop()
		
		this.playing = false;
		
	end
	
	
end
