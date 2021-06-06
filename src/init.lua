local self, data, HTTPS, indexs, ambient = {}, require(script.data), game:GetService("HttpService"), {}, nil;

function self.new(object)
	
	return require(script.objects)(object);

end

function self.start(renderIn)
	
	if not renderIn:FindFirstChild("___________Ambient") then
		
		ambient = Instance.new("Frame");
		ambient.BorderSizePixel = 0;
		ambient.Parent = renderIn;
		ambient.AnchorPoint = Vector2.new(0.5, 0.5);
		ambient.Position = UDim2.new(0.5, 0, 0.5, 0);
		ambient.Size = UDim2.new(1,0,1,0)
		ambient.BackgroundTransparency = 0.8;
		ambient.BackgroundColor3 = Color3.fromRGB(255,255,255);
		ambient.ZIndex = 999999998;
		ambient.Name = "___________Ambient";
		
	end
		
	for index, val in pairs(indexs) do
		
		pcall(function()

			ambient[index] = val;
			
		end)
		
	end
	
	local storage = game.ServerStorage:FindFirstChild("UpsideEngineDataBase")
					or game.ReplicatedStorage:FindFirstChild("UpsideEngineDataBase");
	
	if storage then
		
		local rebuilded = self.rebuildSpace(HTTPS:JSONDecode(storage and string.len(storage.Value) > 1 and storage.Value or {}));
		
		for index, value in pairs(rebuilded) do
			
			self.workspace[index] = value;
			
		end
		
	end
		
	for _, obj in pairs(data.workspace) do
		
		obj.build(renderIn);
		
	end
	
end

function self.rebuildSpace(wkspace)
	
	local space = {};
	
	for name, object in pairs(wkspace) do

		local co = self.new(object.class);
		co(object.modules);
		co.properties = object.properties;
		
		space[co.index] = co;
		
	end
	
	return space;
	
end

self.ambient = setmetatable({}, { 
	
	__index = function(_, index)
		
		return pcall(function() return ambient and ambient[index] or nil; end);
		
	end,
	
	__newindex = function(_, index, value)
	
		
		pcall(function()
			
			if not ambient then
			
				indexs[index] = value;
				
			else
				
				ambient[index] = value;
				
			end
				
		end)
	
end});

self.workspace = data.workspace;

return self;
